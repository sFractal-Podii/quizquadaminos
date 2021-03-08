defmodule QuadquizaminosWeb.TetrisLiveTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Quadquizaminos.Accounts.User

  setup %{conn: conn} do
    user = %User{name: "Quiz Block ", user_id: 40_000_000}
    conn = assign(conn, :current_user, user.user_id)
    [user: user, conn: conn]
  end

  describe "Pausing game:" do
    test "pop up window is displayed when game is paused", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/tetris")

      render_click(view, "start")

      html = render_keydown(view, "keydown", %{"key" => " "})
      assert html =~ "button phx-click=\"unpause\">Continue</button>"
      assert html =~ "<div class=\"phx-modal-content\">"
    end

    test "player can see categories of topics to select", %{conn: conn} do
      categories = Quadquizaminos.QnA.categories()
      {_view, html} = pause_game(conn)

      Enum.each(categories, fn category ->
        category = category |> Macro.camelize()
        assert html =~ "#{category}</button>"
      end)
    end

    test "game continues when continue button is clicked", %{conn: conn} do
      {view, _html} = pause_game(conn)

      html = render_click(view, "unpause")
      refute html =~ "<div class=\"phx-modal-content\">"
    end
  end

  describe "select topic" do
    test "player can select topic of the question to answer", %{conn: conn} do
      categories = Quadquizaminos.QnA.categories()
      {view, _html} = pause_game(conn)

      Enum.map(categories, fn category ->
        html = render_click(view, "choose_category", %{"category" => "#{category}"})
        assert html =~ "Question:"
      end)
    end

    test "game continues when right answer is picked otherwise remains in paused state", %{
      conn: conn
    } do
      [category | _] = Quadquizaminos.QnA.categories()
      {view, _html} = pause_game(conn)

      render_click(view, "choose_category", %{"category" => category})
      right_answer = Quadquizaminos.QnA.question(category).correct

      wrong_answer =
        Enum.find(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"], fn guess ->
          guess != right_answer
        end)

      pause_html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => wrong_answer}})

      continue_html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      assert pause_html =~ "Question:"
      assert pause_html =~ "Continue</button></form>"
      refute continue_html =~ "Continue</button></form>"
    end
  end

  defp pause_game(conn) do
    {:ok, view, _html} = live(conn, "/tetris")

    render_click(view, "start")
    html = render_keydown(view, "keydown", %{"key" => " "})
    {view, html}
  end
end
