defmodule QuadquizaminosWeb.PageController do
  @moduledoc """
  Static page controller
  """
  import Phoenix.LiveView.Controller

  use QuadquizaminosWeb, :controller
  alias Quadquizaminos.UserFromAuth

  def index(conn, _params) do
    user_id = get_session(conn, :user_id)
    render(conn, "index.html", current_user: current_user(user_id))
  end

  def anonymous(conn, _params) do
     conn = assign(conn, :type, "anonymous")
    render(conn, "index.html", [])
  end

  defp current_user(nil), do: nil

  defp current_user(user_id) do
    UserFromAuth.get_user(user_id)
  end
end
