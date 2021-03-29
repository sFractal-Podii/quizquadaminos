defmodule QuadquizaminosWeb.PageController do
  @moduledoc """
  Static page controller
  """

  use QuadquizaminosWeb, :controller
  alias Quadquizaminos.UserFromAuth

  def index(conn, _params) do
    user_id = conn.assigns[:current_user]
    render(conn, "index.html", current_user: current_user(user_id))
  end

  def anonymous(conn, _params) do
    conn
    |> put_flash(:info, "Successfully authenticated.")
    |> put_session(:user, "anonymous")
    |> configure_session(renew: true)
    |> redirect(to: "/")
  end

  defp current_user(nil), do: nil

  defp current_user("anonymous"), do: "anonymous"

  defp current_user(user_id) do
    UserFromAuth.get_user(user_id)
  end
end
