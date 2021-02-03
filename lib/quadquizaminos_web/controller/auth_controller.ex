defmodule QuadquizaminosWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use QuadquizaminosWeb, :controller

  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Quadquizaminos.UserFromAuth

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    auth.uid |> authorized_user?() |> find_or_create(auth, conn)
  end

  defp authorized_user?(user_id), do: user_id in Application.get_env(:quadquizaminos, :github_ids)

  defp find_or_create(true, auth, conn) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user.user_id)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  defp find_or_create(_, _auth, conn) do
    conn
    |> put_flash(:error, "You are not authorized to access the page")
    |> redirect(to: "/")
    |> halt()
  end
end
