defmodule QuadquizaminosWeb.UtilTest do
    use QuadquizaminosWeb.ConnCase
  
    import Phoenix.LiveViewTest
    alias Quadquizaminos.Contests
    alias Quadquizaminos.Contest.ContestAgent
   

    setup %{conn: conn} do
        Contests.create_contest(%{name: "ContestC"})
        conn = get(conn, "/contests")

        [conn: conn]
    end

    test "admin can see the count up timer increase", %{conn: conn}do
        {:ok, view, _html} = live(conn, "/contests")
        assert ContestAgent.time_elapsed("ContestC") == 0
        render_click(view, :start, %{"contest" => "ContestC"})
        assert render(view) =~ "00:00:00" 
        Process.sleep(1000)
        send(view.pid, :timer)
        assert ContestAgent.time_elapsed("ContestC") == 1
        assert render(view) =~ "00:00:01" 
    end

end
