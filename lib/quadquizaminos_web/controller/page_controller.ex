defmodule QuadquizaminosWeb.PageController do
  @moduledoc """
  Static page controller
  """

  use QuadquizaminosWeb, :controller

  def index(conn, _params) do
    IO.inspect(get_session(conn, :current_user), label: "=============================	=")
    render(conn, "index.html", current_user: get_session(conn, :current_user))
  end
end
