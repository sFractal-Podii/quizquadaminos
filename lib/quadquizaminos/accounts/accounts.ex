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
  def user_has_role?(nil, _roles), do: false

  def user_has_role?(current_user, roles) when is_struct(current_user) do
    current_user.role in roles
  end

  def user_has_role?(current_user, roles) do
    current_user = get_user(current_user)
    current_user.role in roles
  end
end
