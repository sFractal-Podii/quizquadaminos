defmodule Quadquizaminos.ContestsTest.RSVP do
  use Quadquizaminos.DataCase
  alias Quadquizaminos.Accounts
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.Contests
  alias Quadquizaminos.Contests.RSVP

  test "create_rsvp/2 creates a new rsvp on db" do
    {:ok, current_user} = Accounts.create_user(%User{}, %{name: "ha", uid: "34"})
    {:ok, contest} = Contests.create_contest(%{name: "test contest"})
    attrs = %{"contest_id" => contest.id}

    {:ok, %RSVP{}} = Contests.create_rsvp(attrs, current_user)
  end
end
