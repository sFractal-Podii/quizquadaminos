defmodule QuadquizaminosWeb.PageControllerTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Quadquizaminos.Accounts.User

  test "user is restricted to access tetris game if not logged in", %{conn: conn} do
    conn = get(conn, "/tetris")
    assert get_flash(conn, :error) == "Please login first"
  end

  test "configured users are given admin role when authenticated", %{conn: conn} do
    auth = %Ueberauth.Auth{
      provider: :github,
      info: %{
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        image: "https://example.com/image.jpg",
        name: "John Doe"
      },
      uid: 4_000_000
    }

    conn
    |> bypass_through(QuadquizaminosWeb.Router, [:browser])
    |> get("/auth/github/callback")
    |> assign(:ueberauth_auth, auth)
    |> QuadquizaminosWeb.AuthController.callback(%{})

    %User{role: "admin"} = Quadquizaminos.Repo.get(User, auth.uid)
  end

  test "non configured users are given player role when authenticated", %{conn: conn} do
    auth = %Ueberauth.Auth{
      provider: :github,
      info: %{
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        image: "https://example.com/image.jpg",
        name: "John Doe"
      },
      uid: 3_000_000
    }

    conn
    |> bypass_through(QuadquizaminosWeb.Router, [:browser])
    |> get("/auth/github/callback")
    |> assign(:ueberauth_auth, auth)
    |> QuadquizaminosWeb.AuthController.callback(%{})

    %User{role: "player"} = Quadquizaminos.Repo.get(User, auth.uid)
  end

  test "users get notified if Successfully authenticated via github", %{conn: conn} do
    auth = %Ueberauth.Auth{
      provider: :github,
      info: %{
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        image: "https://example.com/image.jpg",
        name: "John Doe"
      },
      uid: 4_000_000
    }

    conn =
      conn
      |> bypass_through(QuadquizaminosWeb.Router, [:browser])
      |> get("/auth/github/callback")
      |> assign(:ueberauth_auth, auth)
      |> QuadquizaminosWeb.AuthController.callback(%{})

    assert get_flash(conn, :info) == "Successfully authenticated."
  end

  test "users get notified if Successfully authenticated via google", %{conn: conn} do
    auth = %Ueberauth.Auth{
      provider: :google,
      info: %{
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        image: "https://example.com/image.jpg",
        name: "John Doe"
      },
      uid: "4000000123456"  
    }

    conn =
      conn
      |> bypass_through(QuadquizaminosWeb.Router, [:browser])
      |> get("/auth/google/callback")
      |> assign(:ueberauth_auth, auth)
      |> QuadquizaminosWeb.AuthController.callback(%{})

    assert get_flash(conn, :info) == "Successfully authenticated."
  end

  test "users can access game when logged in anonymously", %{conn: conn} do
    conn =
      conn
      |> post("/anonymous")

    {:ok, _view, html} = live(conn, "/tetris")

    assert html =~ "<h1>Welcome to QuadBlocksQuiz!</h1>"
  end
end
