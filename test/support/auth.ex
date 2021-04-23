ExUnit.start()

defmodule Quadquizaminos.Test.Auth do
  @endpoint QuadquizaminosWeb.Endpoint
  import Phoenix.ConnTest
  use QuadquizaminosWeb.ConnCase

  def login do
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

    Phoenix.ConnTest.build_conn()
    |> bypass_through(QuadquizaminosWeb.Router, [:browser])
    |> get("/auth/github/callback")
    |> assign(:ueberauth_auth, auth)
    |> QuadquizaminosWeb.AuthController.callback(%{})
  end
end
