defmodule QuadquizaminosWeb.Auth do
  @moduledoc """
  Auth plug, checks for the current user and adds them to assigns.
  """
  import Plug.Conn
  use QuadquizaminosWeb, :controller

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      user_id = get_session(conn, :user_id)
      assign(conn, :current_user, user_id)
    end
  end
end
