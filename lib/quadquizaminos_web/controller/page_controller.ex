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

  def instructions(conn, _params) do
    render(conn, "instructions.html")
  end

  def redirect_to_well_known(conn, _params) do
    redirect(conn, to: "/.well-known/sbom")
  end

  def sbom(conn, _params) do
    render(conn, "sbom.html")
  end

  defp current_user(nil), do: nil

  defp current_user("anonymous"), do: "anonymous"

  defp current_user(uid) do
    Accounts.get_user(uid)
  end
end
