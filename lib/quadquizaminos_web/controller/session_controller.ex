defmodule QuadquizaminosWeb.SessionController do
  use QuadquizaminosWeb, :controller
  alias Quadquizaminos.Accounts
  alias Quadquizaminos.Accounts.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"name" => name}}) do
    case Accounts.create_user(%User{}, %{name: name, uid: name}) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> assign(:current_user, user)
        |> put_session(:uid, user.name)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to Login, Try Again!!")
        |> redirect("/sessions/new")
    end
  end

  def anonymous(conn, _params) do
    conn
    |> put_flash(:info, "Successfully authenticated.")
    |> put_session(:uid, "anonymous")
    |> configure_session(renew: true)
    |> redirect(to: "/")
  end
end
