defmodule QuadBlockQuiz.ContestsTest.RSVP do
  use QuadBlockQuiz.DataCase
  alias QuadBlockQuiz.Accounts
  alias QuadBlockQuiz.Accounts.User
  alias QuadBlockQuiz.Contests
  alias QuadBlockQuiz.Contests.RSVP

  describe "RSVP" do
    setup do
      {:ok, current_user} = Accounts.create_user(%User{}, %{name: "ha", uid: "34"})
      {:ok, contest} = Contests.create_contest(%{name: "test contest"})
      attrs = %{"contest_id" => contest.id}

      [attrs: attrs, current_user: current_user, contest: contest]
    end

    test "create_rsvp/2 creates a new rsvp on db", %{attrs: attrs, current_user: current_user} do
      {:ok, %RSVP{}} = Contests.create_rsvp(attrs, current_user)
    end

    test "cancel_rsvp/2 deletes existing rsvp on db", %{
      attrs: attrs,
      current_user: current_user,
      contest: contest
    } do
      {:ok, %RSVP{}} = Contests.create_rsvp(attrs, current_user)

      {:ok, %RSVP{contest_id: id}} = Contests.cancel_rsvp(contest.id, current_user)

      refute Repo.get_by(RSVP, contest_id: id)
    end
  end
end
