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
    setup do
      attrs = %{name: "Quiz Block ", user_id: 1, role: "player"}
      {:ok, user} = Accounts.create_user(%User{}, attrs)

      Enum.each(1..15, fn num ->
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
    end

    test "returns the record of the top 10 played games" do
      assert Records.top_10_games() |> Enum.count() == 10
    end

    test "records are sorted by scores in descending order" do
      actual = [150, 140, 130, 120, 110, 100, 90, 80, 70, 60]

      expected =
        Records.top_10_games()
        |> Enum.map(& &1.score)

      assert actual == expected
    end
  end

  describe "contest game" do
    setup do
      attrs = %{name: "Quiz Block ", user_id: 1, role: "player"}
      {:ok, user} = Accounts.create_user(%User{}, attrs)
      start_times = [~U[2021-04-20 06:00:53Z], ~U[2021-04-20 06:05:53Z], ~U[2021-04-20 05:00:53Z]]
      end_time = DateTime.utc_now()

      Enum.each(start_times, fn start_time ->
        game_record = %{
          start_time: start_time,
          end_time: end_time,
          user_id: user.user_id,
          score: 100,
          dropped_bricks: 10,
          correctly_answered_qna: 2
        }

        Records.record_player_game(true, game_record)
      end)

      [start_times: start_times, end_time: end_time]
    end

    test "contest_game/1 returns game record played during start_time or past start time", %{
      start_times: start_times
    } do
      [start_time | _] = start_times

      assert start_time |> Records.contest_game() |> Enum.count() == 2

      start_time = ~U[2021-04-20 07:00:53Z]

      assert start_time |> Records.contest_game() |> Enum.count() == 0
    end

    test "contest_game/2 returns game record between start_time and end_time", %{
      end_time: end_time
    } do
      start_time = ~U[2021-04-20 05:00:53Z]

      assert start_time |> Records.contest_game(end_time) |> Enum.count() == 3

      start_time = ~U[2021-04-20 07:00:53Z]

      assert start_time |> Records.contest_game(end_time) |> Enum.count() == 0
    end
  end
end
