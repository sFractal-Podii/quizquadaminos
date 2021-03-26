defmodule QuadquizaminosWeb.Authorize do
  @moduledoc """
  Authorization plug
  """
  import Plug.Conn
  use QuadquizaminosWeb, :controller

  def init(opts), do: opts

  def call(conn, _opts) do
    conn.assigns
    |> Map.get(:current_user)
    |> authorize_user(conn)
  end

  defp authorize_user(nil, conn) do
    
    # if Map.get(conn, :type) == "anonymous" do
    #   conn
    #   |> redirect(to: "/tetris")
    # else
      conn
      |> put_flash(:error, "Please login first")
      |> redirect(to: "/")
      |> halt()
    # end
  end

  defp authorize_user(_user, conn), do: conn
end
