defmodule QuadquizaminosWeb.LoginLevelTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Quadquizaminos.Accounts
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.Test.Auth

  test "all sign up button is displayed when there is no login level selected", %{conn: conn} do
    conn = get(conn, "/")
    assert conn.resp_body =~ "Sign in with GitHub"
    assert conn.resp_body =~ "Sign in anonymously"
    assert conn.resp_body =~ "Sign in with Google"
  end

  describe "by_config when selected:" do
    setup do
      # admin logging in
      conn = Auth.login()
      {:ok, view, _html} = live(conn, "/admin/login_levels")
      render_change(view, "login_levels", %{"login_levels" => "by_config"})
      :ok
    end

    test "only admin can play the game" do
      # admin logging in
      conn = Auth.login()
      {:ok, _view, html} = live(conn, "/tetris")
      assert html =~ "Start</button>"
    end

    test "only github sign up button is displayed", %{conn: conn} do
      conn = get(conn, "/")
      assert conn.resp_body =~ "Sign in with GitHub"
      refute conn.resp_body =~ "Sign in anonymously"
      refute conn.resp_body =~ "Sign in with Google"
    end

    test "if users logs in as player with github option they are displayed with a message to indicate game not available" do
      conn = Auth.login("github:player")
      conn = get(conn, "/")
      assert conn.resp_body =~ "<h1>Game not available until RSAC starts</h1>"
    end

    test "if users were logged in via other oauth option other than github, they are displayed with a message to indicate game not available",
         %{conn: conn} do
      attrs = %{name: "Quiz Block ", uid: "12345678", role: "player"}
      Accounts.create_user(%User{}, attrs)

      conn = assign(conn, :current_user, "12345678")
      conn = get(conn, "/")
      assert conn.resp_body =~ "<h1>Game not available until RSAC starts</h1>"
    end

    test "if users were logged in anonymously, they are displayed with a message to indicate game not available",
         %{conn: conn} do
      conn = assign(conn, :current_user, "anonymous")
      conn = get(conn, "/")
      assert conn.resp_body =~ "<h1>Game not available until RSAC starts</h1>"
    end
  end

  describe "oauth_login when selected" do
    setup do
      # admin logging in
      conn = Auth.login()
      {:ok, view, _html} = live(conn, "/admin/login_levels")
      render_change(view, "login_levels", %{"login_levels" => "oauth_login"})
      :ok
    end

    test "anonymous sign up button is hidden", %{conn: conn} do
      conn = get(conn, "/")
      assert conn.resp_body =~ "Sign in with GitHub"
      assert conn.resp_body =~ "Sign in with Google"
      refute conn.resp_body =~ "Sign in anonymously"
    end

    test "players can access the game" do
      conn = Auth.login("github:player")
      {:ok, _view, html} = live(conn, "/tetris")
      assert html =~ "Start</button>"
    end

    test "admin can access the game" do
      conn = Auth.login()
      {:ok, _view, html} = live(conn, "/tetris")
      assert html =~ "Start</button>"
    end

    test "anonymous users cannot access the game" do
      conn = Auth.login("anonymously")
      conn = get(conn, "/")

      assert conn.resp_body =~ "<h1>Game not available until RSAC starts</h1>"
    end
  end

  describe "anonymous_login when selected" do
    setup do
      # admin logging in
      conn = Auth.login()
      {:ok, view, _html} = live(conn, "/admin/login_levels")
      render_change(view, "login_levels", %{"login_levels" => "anonymous_login"})
      :ok
    end

    test "all sign up button is shown", %{conn: conn} do
      conn = get(conn, "/")
      assert conn.resp_body =~ "Sign in with GitHub"
      assert conn.resp_body =~ "Sign in with Google"
      assert conn.resp_body =~ "Sign in anonymously"
    end

    test "anonymous users can access the game" do
      conn = Auth.login("anonymously")
      {:ok, _view, html} = live(conn, "/tetris")
      assert html =~ "Start</button>"
    end

    test "admin can access the game" do
      conn = Auth.login()
      {:ok, _view, html} = live(conn, "/tetris")
      assert html =~ "Start</button>"
    end

    test "players logged with any oauth option can access the game" do
      conn = Auth.login("github:player")
      {:ok, _view, html} = live(conn, "/tetris")
      assert html =~ "Start</button>"
    end
  end
end
