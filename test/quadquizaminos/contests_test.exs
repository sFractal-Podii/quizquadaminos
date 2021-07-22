#create_contest
#get_contest
#list_contests
#active_contests_names


#resume_contest
#contest_status
#time_elapsed
#start_contest
#end_contest
#update_contest

defmodule Quizquadaminos.ContestsTest do
  use Quadquizaminos.DataCase
  alias Quadquizaminos.Contests

  setup do
    attrs = %{name: "ContestC"}
    {:ok, contest} = Contests.create_contest(attrs)
    [contest: contest]
  end

  test "creating a contest", %{contest: contest} do
     assert contest.name == "ContestC"
  end
  test "get contest",%{contest: contest} do
    assert Contests.get_contest("ContestC").name == contest.name
  end

  test "list contests", %{contest: contest} do
    {:ok, contest2} = Contests.create_contest(%{name: "ContestD"})
    assert Contests.list_contests() == [contest, contest2]

  end

end
