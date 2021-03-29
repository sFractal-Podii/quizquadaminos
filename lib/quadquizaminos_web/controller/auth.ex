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
      anonymous_user = get_session(conn, :user)
      assign_current_user(conn, user_id, anonymous_user)
    end
  end

  defp assign_current_user(conn, user_id, nil = _anonymous_user) do
    assign(conn, :current_user, user_id)
  end

  defp assign_current_user(conn, nil = _user_id, anonymous_user) do
    assign(conn, :current_user, anonymous_user)
  end

  defp assign_current_user(conn, user_id, _anonymous_user) do
    assign(conn, :current_user, user_id)
  end
end
