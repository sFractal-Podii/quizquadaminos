ExUnit.start()

defmodule Quadquizaminos.Test.Auth do
  @endpoint QuadquizaminosWeb.Endpoint
  import Phoenix.ConnTest
  use QuadquizaminosWeb.ConnCase

  def login(user \\ "admin")

  def login("anonymously") do
    Phoenix.ConnTest.build_conn()
    |> post("/anonymous")
  end

  def login("github:player") do
    auth = %Ueberauth.Auth{
      provider: :github,
      info: %{
        first_name: "John",
        last_name: "Second",
        email: "john.doe@example.com",
        image: "https://example.com/image.jpg",
        name: "John Second"
      },
      uid: 3_000_000
    }

    Phoenix.ConnTest.build_conn() |> github_login(auth)
  end

  def login("google:player") do
    auth = %Ueberauth.Auth{
      provider: :google,
      info: %{
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        image: "https://example.com/image.jpg",
        name: "John Doe"
      },
      uid: "12345678"
    }

    Phoenix.ConnTest.build_conn() |> google_login(auth)
  end

  def login(_user) do
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

    Phoenix.ConnTest.build_conn() |> github_login(auth)
  end

  defp github_login(conn, auth) do
    conn
    |> bypass_through(QuadquizaminosWeb.Router, [:browser])
    |> get("/auth/github/callback")
    |> assign(:ueberauth_auth, auth)
    |> QuadquizaminosWeb.AuthController.callback(%{})
  end

  defp google_login(conn, auth) do
    conn
    |> bypass_through(QuadquizaminosWeb.Router, [:browser])
    |> get("/auth/google/callback")
    |> assign(:ueberauth_auth, auth)
    |> QuadquizaminosWeb.AuthController.callback(%{})
  end
end
