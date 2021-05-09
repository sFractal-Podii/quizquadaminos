defmodule QuadquizaminosWeb.TetrisLiveTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Quadquizaminos.Test.Auth

  setup do
    conn = Auth.login()
    [conn: conn]
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

    test "choosing correct answer asks player to choose another category", %{conn: conn} do
      [category | _] = Quadquizaminos.QnA.categories()
      {view, _html} = pause_game(conn)

      render_click(view, "choose_category", %{"category" => category})
      right_answer = Quadquizaminos.QnA.question(category).correct
      html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})
      assert html =~ "Continue"
      assert html =~ category |> Macro.camelize()
    end
  end

  describe "Configuring question scoring points" do
    test "scoring points are displayed on qna", %{conn: conn} do
      [category | _] = Quadquizaminos.QnA.categories()
      score = Quadquizaminos.QnA.question(category).score

      {view, _html} = pause_game(conn)
      html = render_click(view, "choose_category", %{"category" => category})

      assert html =~ "<h2>Scores</h2>"
      assert html =~ "Right answer:<b>+#{score["Right"]}</b>"
      assert html =~ "Wrong answer:<b>-#{score["Wrong"]}</b>"
    end

    test "points are added with scores set on qna if answered correctly", %{conn: conn} do
      [category | _] = Quadquizaminos.QnA.categories()
      right_answer = Quadquizaminos.QnA.question(category).correct
      score = Quadquizaminos.QnA.question(category).score

      {view, _html} = pause_game(conn)

      html = render_click(view, "choose_category", %{"category" => category})
      assert html =~ "Total Score:</b>0</h2>"

      continue_html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      assert continue_html =~ "<h1>#{score["Right"]}</h1>"
    end

    test "points are deducted with scores set on qna if answered wrongly", %{conn: conn} do
      [category | t] = Quadquizaminos.QnA.categories()
      right_answer = Quadquizaminos.QnA.question(category).correct
      score = Quadquizaminos.QnA.question(category).score

      {view, _html} = pause_game(conn)

      render_click(view, "choose_category", %{"category" => category})

      html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      assert html =~ "<h1>#{score["Right"]}</h1>"

      render_keydown(view, "keydown", %{"key" => " "})

      # select next category
      next_category = t |> hd()

      right_answer = Quadquizaminos.QnA.question(next_category).correct
      next_score = Quadquizaminos.QnA.question(next_category).score

      render_click(view, "choose_category", %{"category" => next_category})

      wrong_answer =
        Enum.find(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"], fn guess ->
          guess != right_answer
        end)

      pause_html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => wrong_answer}})

      total_score =
        (score["Right"] |> String.to_integer()) - (next_score["Wrong"] |> String.to_integer())

      assert pause_html =~ "<h1>#{total_score}</h1><h2>Score</h2>"
    end

    test "player remains on the same question when wrongly answered", %{conn: conn} do
      right_answer = Quadquizaminos.QnA.question("open_c2").correct

      {view, _html} = pause_game(conn)

      render_click(view, "choose_category", %{"category" => "open_c2"})

      wrong_answer =
        Enum.find(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"], fn guess ->
          guess != right_answer
        end)

      html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => wrong_answer}})
      assert html =~ "<h1>\nQuestion:"
      assert html =~ "<h2> Answer </h2>"
    end
  end

  defp pause_game(conn) do
    {:ok, view, _html} = live(conn, "/tetris")

    render_click(view, "start")
    html = render_keydown(view, "keydown", %{"key" => " "})
    {view, html}
  end
end
