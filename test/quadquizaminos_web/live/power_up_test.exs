defmodule QuadquizaminosWeb.PowerUpTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Quadquizaminos.Accounts.User

  setup %{conn: conn} do
    user = %User{name: "Quiz Block ", user_id: 40_000_000}
    conn = assign(conn, :current_user, user.user_id)
    [user: user, conn: conn]
  end
end
