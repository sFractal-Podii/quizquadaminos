defmodule Quadquizaminos.AccountTest do
  use Quadquizaminos.DataCase
  alias Quadquizaminos.Accounts
  alias Quadquizaminos.Accounts.LoginLevel
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.Repo

  test "user_has_role?/2 checks if user matches the role given" do
    attrs = %{name: "Quiz Block ", user_id: 40_000_000, role: "admin"}
    {:ok, user} = Accounts.create_user(%User{}, attrs)
    assert Accounts.user_has_role?(user.user_id, ["admin"])
    assert Accounts.user_has_role?(user, ["admin"])
    refute Accounts.user_has_role?("anonymous", ["admin"])
    refute Accounts.user_has_role?(user.user_id, ["player"])
  end

  test "update_login_level/2 updates selected login_level to true and unselected to false" do
    Accounts.update_login_level("by_config", "anonymous_login")
    %LoginLevel{active: true} = Repo.get_by(LoginLevel, name: "by_config")
    Accounts.update_login_level("anonymous_login", "by_config")
    %LoginLevel{active: false} = Repo.get_by(LoginLevel, name: "by_config")
  end
end
