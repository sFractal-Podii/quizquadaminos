defmodule Quadquizaminos.Accounts do
  alias Quadquizaminos.Accounts.LoginLevel
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

  def get_login_level(level) do
    Repo.get_by(LoginLevel, name: level)
  end

  def update_login_level(selected_level, initially_selected_level) do
    initially_selected_query =
      LoginLevel.base_query()
      |> LoginLevel.by_name(initially_selected_level)

    selected_level_query =
      LoginLevel.base_query()
      |> LoginLevel.by_name(selected_level)

    Ecto.Multi.new()
    |> Ecto.Multi.update_all(:selected_level, selected_level_query, set: [active: true])
    |> Ecto.Multi.update_all(:initially_selected, initially_selected_query, set: [active: false])
    |> Repo.transaction()
  end
end
