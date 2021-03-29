defmodule QuadquizaminosWeb.AnonymousAuth do
    @moduledoc """
    Auth plug, checks for the type (anonymous)and adds them to assigns.
    """
    import Plug.Conn
    use QuadquizaminosWeb, :controller
  
    def init(opts), do: opts
  
    def call(conn, _opts) do
      if conn.assigns[:type] do
        conn
      else
        assign(conn, :type, "anonymous")
      end
    end
  end
  