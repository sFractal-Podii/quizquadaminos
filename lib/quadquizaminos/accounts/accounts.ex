defmodule Quadquizaminos.Accounts do
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.Repo

  def create_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(id) do
    User
    |> Repo.get(id)
  end

  def user_has_role?("anonymous", _roles), do: false

  def user_has_role?(user_id, roles) do
    user = get_user(user_id)
    user.role in roles
  end
end
