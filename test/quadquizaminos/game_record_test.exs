defmodule Quadquizaminos.GameRecordTest do
  use Quadquizaminos.DataCase
  alias Quadquizaminos.{Accounts, GameBoard, Repo}
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.GameBoard.Records

  describe "record_player_game/2:" do
    setup do
      attrs = %{name: "Quiz Block ", user_id: 30_000_000, role: "player"}
      {:ok, user} = Accounts.create_user(%User{}, attrs)

      game_record = %{
        start_time: ~U[2021-04-20 06:00:53Z],
        end_time: DateTime.utc_now(),
        user_id: user.user_id,
        score: 100,
        dropped_bricks: 10,
        correctly_answered_qna: 2
      }

      [user: user, game_record: game_record]
    end

    test "saves player game record into the db when game is over", %{
      user: user,
      game_record: game_record
    } do
      user_id = user.user_id
      score = game_record.score

      Records.record_player_game(true, game_record)
      %GameBoard{score: ^score} = Repo.get_by(GameBoard, user_id: user_id)
    end

    test "doesn't persist anonymous player game records into the db", %{game_record: game_record} do
      game_record = %{game_record | user_id: "anonymous"}

      Records.record_player_game(true, game_record)
      assert Repo.all(GameBoard) == []
    end
  end

  describe "top_10_games/0" do
    test "returns the record of the top 10 played games" do
      Enum.each(1..15, fn num ->
        attrs = %{name: "Quiz Block ", user_id: num, role: "player"}
        {:ok, user} = Accounts.create_user(%User{}, attrs)

        game_record = %{
          start_time: ~U[2021-04-20 06:00:53Z],
          end_time: DateTime.utc_now(),
          user_id: user.user_id,
          score: 10 * num,
          dropped_bricks: 10,
          correctly_answered_qna: 2
        }

        Records.record_player_game(true, game_record)
      end)

      assert Records.top_10_games() |> Enum.count() == 10
    end

    test "returns distinct records of the top 10 played games" do
      attrs = %{name: "Quiz Block ", user_id: 31_000_000, role: "player"}
      {:ok, user} = Accounts.create_user(%User{}, attrs)

      Enum.each(1..5, fn _num ->
        game_record = %{
          start_time: ~U[2021-04-20 06:00:53Z],
          end_time: DateTime.utc_now(),
          user_id: user.user_id,
          score: 100,
          dropped_bricks: 10,
          correctly_answered_qna: 2
        }

        Records.record_player_game(true, game_record)
      end)

      assert Records.top_10_games() |> Enum.count() == 1
    end
  end
end
