defmodule Quadquizaminos.UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """
  require Logger
  require Jason

  alias Ueberauth.Auth
  alias Quadquizaminos.Accounts
  alias Quadquizaminos.Accounts.User

  def find_or_create(%Auth{} = auth) do
    case Accounts.get_user(uid(auth)) do
      nil ->
        Accounts.create_user(%User{}, basic_info(auth))

      user ->
        {:ok, user}
    end
  end

  # github does it this way
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}, provider: :github}), do: image
  defp avatar_from_auth(%{info: %{image: image}, provider: _provider}), do: image

  # default case if nothing matches
  defp avatar_from_auth(auth) do
    Logger.warn("#{auth.provider} needs to find an avatar URL!")
    nil
  end

  defp basic_info(auth) do
    %{
      uid: uid(auth),
      name: name_from_auth(auth),
      avatar: avatar_from_auth(auth),
      role: auth.uid |> configured_user?() |> role(),
      provider: Atom.to_string(auth.provider),
      email: auth.info.email
    }
  end

  defp uid(auth) do
    case auth.provider do
      :linkedin -> auth.uid
      :google -> String.slice(auth.uid, 0, 8)
      _ -> Integer.to_string(auth.uid)
    end
  end

  defp role(true = _configured_user?), do: "admin"

  defp role(_configured_user?), do: "player"

  defp configured_user?(uid), do: uid in Application.get_env(:quadquizaminos, :github_ids)

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
