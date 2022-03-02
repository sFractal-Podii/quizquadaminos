defmodule QuadBlockQuiz.AccountTest do
  use QuadBlockQuiz.DataCase
  alias QuadBlockQuiz.Accounts
  alias QuadBlockQuiz.Accounts.LoginLevel
  alias QuadBlockQuiz.Accounts.User
  alias QuadBlockQuiz.Repo

  test "user_has_role?/2 checks if user matches the role given" do
    attrs = %{name: "Quiz Block ", uid: Integer.to_string(40_000_000), role: "admin"}
    {:ok, user} = Accounts.create_user(%User{}, attrs)
    assert Accounts.user_has_role?(user.uid, ["admin"])
    assert Accounts.user_has_role?(user, ["admin"])
    refute Accounts.user_has_role?("anonymous", ["admin"])
    refute Accounts.user_has_role?(user.uid, ["player"])
  end

  test "update_login_level/2 updates selected login_level to true and unselected to false" do
    Accounts.update_login_level("by_config", "anonymous_login")
    %LoginLevel{active: true} = Repo.get_by(LoginLevel, name: "by_config")
    Accounts.update_login_level("anonymous_login", "by_config")
    %LoginLevel{active: false} = Repo.get_by(LoginLevel, name: "by_config")
  end
end
