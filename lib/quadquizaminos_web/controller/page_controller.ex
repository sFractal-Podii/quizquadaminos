defmodule QuadquizaminosWeb.PageController do
  @moduledoc """
  Static page controller
  """

  use QuadquizaminosWeb, :controller
  alias Quadquizaminos.Accounts

  def index(conn, _params) do
    uid = conn.assigns[:current_user]
    render(conn, "index.html", current_user: current_user(uid))
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
