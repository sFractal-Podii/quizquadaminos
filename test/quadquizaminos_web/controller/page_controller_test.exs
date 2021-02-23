defmodule QuadquizaminosWeb.PageControllerTest do
  use QuadquizaminosWeb.ConnCase

  test "user is restricted to access tetris game if not logged in", %{conn: conn} do
    conn = get(conn, "/tetris")
    assert get_flash(conn, :error) == "Please login first"
  end

  test "non configured players are restricted from accessing tetris game", %{conn: conn} do
    auth = %Ueberauth.Auth{
      provider: :github,
      info: %{
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        image: "https://example.com/image.jpg"
      }
    }

    conn =
      conn
      |> bypass_through(QuadquizaminosWeb.Router, [:browser])
      |> get("/auth/github/callback")
      |> assign(:ueberauth_auth, auth)
      |> QuadquizaminosWeb.AuthController.callback(%{})

    assert get_flash(conn, :error) == "You are not authorized to access the page"
  end

  test "configured players get notified if Successfully authenticated", %{conn: conn} do
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
end
