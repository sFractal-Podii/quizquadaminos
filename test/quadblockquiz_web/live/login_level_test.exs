defmodule QuadblockquizWeb.LoginLevelTest do
  use QuadblockquizWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Quadblockquiz.Accounts
  alias Quadblockquiz.Accounts.User
  alias Quadblockquiz.Test.Auth

  test "all sign up button is displayed when there is no login level selected", %{conn: conn} do
    conn = get(conn, "/")
    assert conn.resp_body =~ "GitHub\n</a>"
    assert conn.resp_body =~ "Google"
  end

  describe "by_config when selected:" do
    setup do
      # admin logging in
      conn = Auth.login()
      {:ok, view, _html} = live(conn, "/admin")
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
      assert conn.resp_body =~ "Github Sign In"
      refute conn.resp_body =~ "Sign in anonymously"
      refute conn.resp_body =~ "\n   Google\n"
    end

    test "if users logs in as player with github option they are displayed with a message to indicate game not available" do
      conn = Auth.login("github:player")
      conn = get(conn, "/")

      assert conn.resp_body =~
               "Game not available until workshop starts"
    end

    test "if users were logged in via other oauth option other than github, they are displayed with a message to indicate game not available",
         %{conn: conn} do
      attrs = %{name: "Quiz Block ", uid: "12345678", role: "player"}
      Accounts.create_user(%User{}, attrs)

      conn = assign(conn, :current_user, "12345678")
      conn = get(conn, "/")

      assert conn.resp_body =~
               "Game not available until workshop starts"
    end

    test "if users were logged in anonymously, they are displayed with a message to indicate game not available",
         %{conn: conn} do
      conn = assign(conn, :current_user, "anonymous")
      conn = get(conn, "/")

      assert conn.resp_body =~
               "Game not available until workshop starts"
    end
  end

  describe "oauth_login when selected" do
    setup do
      # admin logging in
      conn = Auth.login()
      {:ok, view, _html} = live(conn, "/admin")
      render_change(view, "login_levels", %{"login_levels" => "oauth_login"})
      :ok
    end

    test "anonymous sign up button is hidden", %{conn: conn} do
      conn = get(conn, "/")
      assert conn.resp_body =~ "GitHub"
      assert conn.resp_body =~ "Google"
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

      assert conn.resp_body =~
               "Game not available until workshop starts"
    end
  end

  describe "anonymous_login when selected" do
    setup do
      # admin logging in
      conn = Auth.login()
      {:ok, view, _html} = live(conn, "/admin")
      render_change(view, "login_levels", %{"login_levels" => "anonymous_login"})
      :ok
    end

    test "all sign up button is shown", %{conn: conn} do
      conn = get(conn, "/")
      assert conn.resp_body =~ "GitHub"
      assert conn.resp_body =~ "Google"
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
