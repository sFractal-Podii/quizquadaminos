defmodule QuadquizaminosWeb.PageController do
  @moduledoc """
  Static page controller
  """

  use QuadquizaminosWeb, :controller
  alias Quadquizaminos.Accounts
  alias Quadquizaminos.GameBoard.Records

  def index(conn, _params) do
    login_level = Accounts.get_selected_login_level()
    uid = conn.assigns[:current_user]

    render(conn, "index.html",
      current_user: current_user(uid),
      game_available: Records.game_available?(uid, login_level)
    )
  end

  def anonymous(conn, _params) do
    conn
    |> put_flash(:info, "Successfully authenticated.")
    |> put_session(:uid, "anonymous")
    |> configure_session(renew: true)
    |> redirect(to: "/")
  end

  defp current_user(nil), do: nil

  defp current_user("anonymous"), do: "anonymous"

  defp current_user(uid) do
    Accounts.get_user(uid)
  end
end
