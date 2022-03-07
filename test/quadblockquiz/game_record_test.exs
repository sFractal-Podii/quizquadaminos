defmodule Quadblockquiz.GameRecordTest do
  use Quadblockquiz.DataCase
  alias Quadblockquiz.{Accounts, GameBoard, Repo}
  alias Quadblockquiz.Accounts.User
  alias Quadblockquiz.GameBoard.Records

  describe "record_player_game/2:" do
    setup do
      attrs = %{name: "Quiz Block ", uid: Integer.to_string(30_000_000), role: "player"}
      {:ok, user} = Accounts.create_user(%User{}, attrs)

      game_record = %{
        start_time: ~U[2021-04-20 06:00:53Z],
        end_time: DateTime.utc_now(),
        uid: user.uid,
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
      uid = user.uid
      score = game_record.score

      Records.record_player_game(true, game_record)
      %GameBoard{score: ^score} = Repo.get_by(GameBoard, uid: uid)
    end

    test "doesn't persist anonymous player game records into the db", %{game_record: game_record} do
      game_record = %{game_record | uid: "anonymous"}

      Records.record_player_game(true, game_record)
      assert Repo.all(GameBoard) == []
    end
  end

  describe "top_10_games/0" do
    setup do
      attrs = %{name: "Quiz Block ", uid: Integer.to_string(1), role: "player"}
      {:ok, user} = Accounts.create_user(%User{}, attrs)

      Enum.each(15..1, fn _num ->
        game_record = %{
          start_time: ~U[2021-04-20 06:00:53Z],
          end_time: DateTime.utc_now(),
          uid: user.uid,
          score: :rand.uniform(50),
          dropped_bricks: :rand.uniform(1000),
          correctly_answered_qna: :rand.uniform(45)
        }

        Records.record_player_game(true, game_record)
      end)
    end

    test "returns the record of the top 10 played games" do
      assert Records.top_10_games() |> Enum.count() == 10
    end

    test "records are sorted by scores in descending order by default" do
      results =
        Records.top_10_games()
        |> Enum.map(& &1.score)

      sorted = results |> Enum.sort(:desc)

      assert results == sorted
    end

    test "record can be sorted by bricks" do
      res =
        Records.top_10_games("dropped_bricks")
        |> Enum.map(& &1.dropped_bricks)

      ordered_bricks = res |> Enum.sort(:desc)

      assert ordered_bricks == res
    end

    test "records can be sorted by  questions" do
      res =
        Records.top_10_games("correctly_answered_qna")
        |> Enum.map(& &1.correctly_answered_qna)

      ordered_bricks = res |> Enum.sort(:desc)

      assert ordered_bricks == res
    end
  end

  test "sorts by time taken by default" do
    attrs = %{name: "Quiz Block ", uid: "2", role: "player"}
    {:ok, user} = Accounts.create_user(%User{}, attrs)
    now = DateTime.utc_now()

    less_time = %{
      start_time: DateTime.add(now, 1000),
      end_time: DateTime.utc_now(),
      uid: user.uid,
      score: 50,
      dropped_bricks: :rand.uniform(1000),
      correctly_answered_qna: :rand.uniform(45)
    }

    more_time = %{
      start_time: DateTime.add(now, 20_000),
      end_time: DateTime.utc_now(),
      uid: user.uid,
      score: 50,
      dropped_bricks: :rand.uniform(1000),
      correctly_answered_qna: :rand.uniform(45)
    }

    {:ok, %Quadblockquiz.GameBoard{id: less_id}} = Records.record_player_game(true, less_time)
    {:ok, %Quadblockquiz.GameBoard{id: more_id}} = Records.record_player_game(true, more_time)

    [more, less] = Records.top_10_games()
    assert less.id == less_id
    assert more.id == more_id
  end

  describe "contest game" do
    setup do
      attrs = %{name: "Quiz Block ", uid: "1", role: "player"}
      {:ok, user} = Accounts.create_user(%User{}, attrs)
      start_times = [~U[2021-04-20 06:00:53Z], ~U[2021-04-20 06:05:53Z], ~U[2021-04-20 05:00:53Z]]
      end_time = DateTime.utc_now()

      Enum.each(start_times, fn start_time ->
        game_record = %{
          start_time: start_time,
          end_time: end_time,
          uid: user.uid,
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
