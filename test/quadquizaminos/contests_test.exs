defmodule Quizquadaminos.ContestsTest do
  use Quadquizaminos.DataCase
  alias Quadquizaminos.Contests

  setup do

    {:ok, contest} = Contests.create_contest(%{name: "ContestC"})
    {:ok, {:ok, started_contest}}= Contests.start_contest("ContestC")

    [contest: contest, started_contest: started_contest]
  end

  test "create_contets/1 creates a contest", %{contest: contest} do
     assert contest.name == "ContestC"
  end
  test "get_contest/1 gets the contest",%{contest: contest} do
    assert Contests.get_contest("ContestC").name == contest.name
  end

  test "list_contests/0 lists all the contest created", %{started_contest: started_contest} do
    Contests.create_contest(%{name: "ContestD"})
    {:ok, {:ok, contest2}}= Contests.start_contest("ContestD")
    assert Contests.list_contests() == [started_contest, contest2]

  end

  test "start_contest/1 starts a contest", %{started_contest: started_contest} do
    refute is_nil(started_contest.start_time)
  end


  test "contest_status/1 gets the contest's status" do
  status = Contests.contest_status("ContestC")
  assert status == :running
  end

  test "end_contest/1 ends the contest" do
    {:ok, {:ok, contest}}= Contests.end_contest("ContestC")
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

end
