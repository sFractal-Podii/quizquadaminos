defmodule Quadquizaminos.ContestsTest do
  use Quadquizaminos.DataCase
  alias Quadquizaminos.{Accounts, Contests}
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.GameBoard.Records

  describe "contest_game_records/2" do
    setup do
      attrs = %{name: "Quiz Block ", uid: Integer.to_string(40_000_000), role: "admin"}
      {:ok, user} = Accounts.create_user(%User{}, attrs)

      {:ok, contest} =
        Contests.create_contest(%{
          end_time: ~U[2021-07-21 17:59:59.000000Z],
          start_time: ~U[2021-07-21 15:59:59.000000Z],
          name: "contestA"
        })

      Enum.each(1..6, fn x ->
        game_attr = %{
          contest_id: contest.id,
          correctly_answered_qna: x,
          dropped_bricks: 10 * x,
          end_time: DateTime.add(~U[2021-07-21 14:59:59.000000Z], 3600 * x, :second),
          score: 100 * x,
          start_time: DateTime.add(~U[2021-07-21 14:59:59.000000Z], 3600 * x, :second),
          uid: user.uid
        }

        Records.create_record(game_attr)
      end)

      [contest: contest]
    end

    test "Fetches the game records of a given contest", %{contest: contest} do
      game_records = contest |> Contests.contest_game_records()
      assert game_records |> Enum.count() == 5

      assert Enum.all?(game_records, fn record ->
               record.start_time >= contest.start_time and record.end_time <= contest.end_time
             end)
    end

    test "records are sorted by scores in descending order by default", %{contest: contest} do
      res = contest |> Contests.contest_game_records() |> Enum.map(& &1.score)
      sorted = res |> Enum.sort(:desc)

      assert sorted == res
    end

    test "records can be sorted by bricks", %{contest: contest} do
      res = contest |> Contests.contest_game_records() |> Enum.map(& &1.dropped_bricks)

      sorted = res |> Enum.sort(:desc)

      assert sorted == res
    end
  end

  test "sorts by time taken by default" do
    attrs = %{name: "Quiz Block ", uid: "2", role: "player"}
    {:ok, user} = Accounts.create_user(%User{}, attrs)

    {:ok, contest} =
      Contests.create_contest(%{
        end_time: ~U[2021-07-21 17:59:59.000000Z],
        start_time: ~U[2021-07-21 15:59:59.000000Z],
        name: "contestB"
      })

    less_time = %{
      start_time: DateTime.add(~U[2021-07-21 14:59:59.000000Z], 7200, :second),
      end_time: DateTime.add(~U[2021-07-21 14:59:59.000000Z], 3600 * 3, :second),
      uid: user.uid,
      contest_id: contest.id,
      score: 50,
      dropped_bricks: 20,
      correctly_answered_qna: 2
    }

    more_time = %{
      start_time: DateTime.add(~U[2021-07-21 14:59:59.000000Z], 3600, :second),
      end_time: DateTime.add(~U[2021-07-21 14:59:59.000000Z], 3600 * 3, :second),
      uid: user.uid,
      contest_id: contest.id,
      score: 50,
      dropped_bricks: 40,
      correctly_answered_qna: 3
    }

    {:ok, %Quadquizaminos.GameBoard{id: less_id}} = Records.create_record(less_time)

    {:ok, %Quadquizaminos.GameBoard{id: more_id}} = Records.create_record(more_time)

    [less, more] = Contests.contest_game_records(contest)
    assert less.id == less_id
    assert more.id == more_id
  end
end
