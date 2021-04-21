defmodule QuadquizaminosWeb.Authorize do
  @moduledoc """
  Authorization plug
  """
  import Plug.Conn
  use QuadquizaminosWeb, :controller

  alias Quadquizaminos.Accounts

  def init(opts), do: opts

  def call(conn, roles: roles) do
    current_user = Map.get(conn.assigns, :current_user)

    if Accounts.user_has_role?(current_user, roles) do
      conn
    else
      conn
      |> put_flash(:error, "You're not authorized to access this page")
      |> redirect(to: "/")
      |> halt()
    end
  end

  def call(conn, _opts) do
    current_user = Map.get(conn.assigns, :current_user)
    authorize_user(conn, current_user)
  end

  defp authorize_user(conn, current_user) do
    if current_user do
      conn
    else
      conn
      |> put_flash(:error, "Please login first")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
