defmodule QuadquizaminosWeb.Authorize do
  @moduledoc """
  Authorization plug
  """
  import Plug.Conn
  use QuadquizaminosWeb, :controller

  def init(opts), do: opts

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
