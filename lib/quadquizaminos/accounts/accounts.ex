defmodule Quadquizaminos.Accounts do
  alias Quadquizaminos.Accounts.LoginLevel
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.Repo

  def create_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def find_or_create(name) do
    case get_user(name) do
      nil ->
        create_user(%User{}, %{name: name, uid: name})

      user ->
        {:ok, user}
    end
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

  def get_selected_login_level do
    LoginLevel.selected_level()
    |> Repo.one()
  end

  def change_user(user, attrs \\ %{})
  def change_user(nil, _attrs), do: :user

  def change_user(user, attrs) do
    User.changeset(user, attrs)
  end

  def update_email(%{"uid" => uid} = attrs) do
    uid |> get_user() |> update_email(attrs)
  end

  def update_email(%User{} = user, attrs) do
    user |> User.email_changeset(attrs) |> Repo.update()
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

  def current_user("anonymous") do
    %User{name: "anonymous", uid: "anonymous", admin?: false}
  end

  def current_user(uid) do
    get_user(uid)
  end

  def has_email?(user) do
    if user.name == "anonymous" or user.email do
      true
    else
      false
    end
  end
end
