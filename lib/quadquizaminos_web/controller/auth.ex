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
      uid = get_session(conn, :uid)
      anonymous_user = get_session(conn, :user)
      assign_current_user(conn, uid, anonymous_user)
    end
  end

  defp assign_current_user(conn, uid, nil = _anonymous_user) do
    assign(conn, :current_user, uid)
  end

  defp assign_current_user(conn, nil = _uid, anonymous_user) do
    assign(conn, :current_user, anonymous_user)
  end

  defp assign_current_user(conn, uid, _anonymous_user) do
    assign(conn, :current_user, uid)
  end
end
