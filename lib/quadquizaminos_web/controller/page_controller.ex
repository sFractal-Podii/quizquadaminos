defmodule QuadquizaminosWeb.PageController do
  @moduledoc """
  Static page controller
  """

  use QuadquizaminosWeb, :controller
  alias Quadquizaminos.UserFromAuth

  def index(conn, _params) do
    user_id = get_session(conn, :current_user)
    render(conn, "index.html", current_user: current_user(user_id))
  end

  defp current_user(nil), do: nil

  defp current_user(user_id) do
    UserFromAuth.get_user(user_id)
  end
end
