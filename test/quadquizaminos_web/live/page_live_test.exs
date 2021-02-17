defmodule QuadquizaminosWeb.PageLiveTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  test "users are required to sign up first to access the game", %{conn: conn} do
    {:error, {:redirect, %{to: "/"}}} =
      live(conn, Routes.live_path(conn, QuadquizaminosWeb.TetrisLive))
  end
end
