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
      assert html =~ "<button type=\"submit\">Continue</button></form>"
      assert html =~ "<div class=\"phx-modal-content\">"
    end

    test "game continues when right answer is picked otherwise remains in paused state", %{
      conn: conn
    } do
      right_answer = question().correct

      wrong_answer = Enum.find(["1", "2", "3", "4"], fn guess -> guess != right_answer end)

      {:ok, view, _html} = live(conn, "/tetris")

      render_click(view, "start")

      render_keydown(view, "keydown", %{"key" => " "})

      pause_html =
        render_submit(view, "check_answer", %{"quiz" => %{"guess" => "#{wrong_answer}"}})

      continue_html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      assert pause_html =~ "Question:"
      assert pause_html =~ "<button type=\"submit\">Continue</button></form>"
      refute continue_html =~ "<button type=\"submit\">Continue</button></form>"
    end
  end

  defp question do
    Quadquizaminos.QnA.question()
  end
end
