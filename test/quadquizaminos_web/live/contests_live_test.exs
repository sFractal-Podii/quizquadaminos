defmodule QuadquizaminosWeb.ContestsLiveShowTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Quadquizaminos.Contests
  alias Quadquizaminos.Test.Auth

  setup do
    Contests.create_contest(%{
      name: "contestA"
    })

    :ok
  end

  test "only admin can see the start, stop button" do
    conn = Auth.login()
    {:ok, _view, html} = live(conn, "/contests")

    assert html =~ "<button class=\"  icon-button\" phx-click=\"start\""
    assert html =~ "<button class=\"disabled  icon-button\" phx-click=\"stop\""
  end

  test "only admin can see option to create contest" do
    conn = Auth.login()
    {:ok, _view, html} = live(conn, "/contests")

    assert html =~ "<input type=\"text\""
  end
end
