defmodule QuadquizaminosWeb.AdminLiveTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Quadquizaminos.Test.Auth

  test "admins can access admins dashboard" do
    # admin logging in
    conn = Auth.login()

    {:ok, _view, html} = live(conn, "/admin/login_levels")

    assert html =~ "<h1>users level of login</h1>"
  end
end
