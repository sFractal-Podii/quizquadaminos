defmodule QuadquizaminosWeb.LeaderboardLiveTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest

  test "users can access leaderboard", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/leaderboard")

    assert html =~ "<h1>Leaderboard</h1>"
  end
end
