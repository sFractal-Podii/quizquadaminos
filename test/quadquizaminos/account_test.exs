defmodule Quadquizaminos.AccountTest do
  use Quadquizaminos.DataCase
  alias Quadquizaminos.Accounts
  alias Quadquizaminos.Accounts.User

  test "user_has_role?/2 checks if user matches the role given" do
    attrs = %{name: "Quiz Block ", user_id: 40_000_000, role: "admin"}
    {:ok, user} = Accounts.create_user(%User{}, attrs)
    assert Accounts.user_has_role?(user.user_id, ["admin"])
    assert Accounts.user_has_role?(user, ["admin"])
    refute Accounts.user_has_role?("anonymous", ["admin"])
    refute Accounts.user_has_role?(user.user_id, ["player"])
  end
end
