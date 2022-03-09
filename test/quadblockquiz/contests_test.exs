defmodule Quizquadaminos.ContestsTest do
  use Quadblockquiz.DataCase
  alias Quadblockquiz.{Accounts, Contests}
  alias Quadblockquiz.Accounts.User
  alias Quadblockquiz.GameBoard.Records

  setup do
    {:ok, contest} = Contests.create_contest(%{name: "ContestC"})
    {:ok, {:ok, started_contest}} = Contests.start_contest("ContestC")

    [contest: contest, started_contest: started_contest]
  end

  test "create_contets/1 creates a contest", %{contest: contest} do
    assert contest.name == "ContestC"
  end

  test "get_contest/1 gets the contest", %{contest: contest} do
    assert Contests.get_contest("ContestC").name == contest.name
  end

  test "list_contests/0 lists all the contest created", %{started_contest: started_contest} do
    Contests.create_contest(%{name: "ContestD"})
    {:ok, {:ok, contest2}} = Contests.start_contest("ContestD")
    assert Contests.list_contests() == [contest2, started_contest]
  end

  test "start_contest/1 starts a contest", %{started_contest: started_contest} do
    refute is_nil(started_contest.start_time)
  end

  test "contest_status/1 gets the contest's status" do
    status = Contests.contest_status("ContestC")
    assert status == :running
  end

  test "end_contest/1 ends the contest" do
    {:ok, {:ok, contest}} = Contests.end_contest("ContestC")
    refute is_nil(contest.end_time)
  end

  test "active_contests_names/0 get the active contests" do
    contest = Contests.active_contests_names()
    assert contest == ["ContestC"]
  end

  test "update_contest/2 updates a contest", %{contest: contest} do
    {:ok, updated_contest} = Contests.update_contest(contest, %{name: "ContestE"})
    assert updated_contest.name == "ContestE"
  end

  test "time_elapsed/1 gets time elapsed " do
    Process.sleep(1000)
    time_elapsed = Contests.time_elapsed("ContestC")
    refute time_elapsed == 0
  end

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
      assert game_records |> Enum.count() == 3

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

    {:ok, %Quadblockquiz.GameBoard{id: less_id}} = Records.create_record(less_time)

    {:ok, %Quadblockquiz.GameBoard{id: more_id}} = Records.create_record(more_time)

    [less, more] = Contests.contest_game_records(contest)
    assert less.id == less_id
    assert more.id == more_id
  end
end
