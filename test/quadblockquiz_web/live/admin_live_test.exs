defmodule QuadblockquizWeb.AdminLiveTest do
  use QuadblockquizWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Quadblockquiz.Accounts.LoginLevel
  alias Quadblockquiz.Repo
  alias Quadblockquiz.Test.Auth

  setup do
    # admin logging in
    conn = Auth.login()

    [conn: conn]
  end

  test "admins can access admins dashboard", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin")

    assert html =~ "<h1>users level of login</h1>"
  end

  test "admins has ability to turn on/off user login level", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/admin")

    render_change(view, "login_levels", %{"login_levels" => "by_config"})
    %LoginLevel{active: true} = Repo.get_by(LoginLevel, name: "by_config")
    render_change(view, "login_levels", %{"login_levels" => "anonymous_login"})
    %LoginLevel{active: false} = Repo.get_by(LoginLevel, name: "by_config")
    %LoginLevel{active: true} = Repo.get_by(LoginLevel, name: "anonymous_login")
  end
end
