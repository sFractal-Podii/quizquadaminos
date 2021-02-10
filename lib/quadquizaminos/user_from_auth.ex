defmodule Quadquizaminos.UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """
  require Logger
  require Jason

  alias Ueberauth.Auth
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.Repo

  def find_or_create(%Auth{} = auth) do
    case get_user(auth.uid) do
      nil ->
        create_user(%User{}, basic_info(auth))

      user ->
        {:ok, user}
    end
  end

  def create_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(id) do
    User
    |> Repo.get(id)
  end

  # github does it this way
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  # default case if nothing matches
  defp avatar_from_auth(auth) do
    Logger.warn("#{auth.provider} needs to find an avatar URL!")
    Logger.debug(Jason.encode!(auth))
    nil
  end

  defp basic_info(auth) do
    %{user_id: auth.uid, name: name_from_auth(auth), avatar: avatar_from_auth(auth)}
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if Enum.empty?(name) do
        auth.info.nickname
      else
        Enum.join(name, " ")
      end
    end
  end
end
