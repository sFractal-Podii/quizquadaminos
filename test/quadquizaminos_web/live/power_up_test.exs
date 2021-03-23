defmodule QuadquizaminosWeb.PowerUpTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Quadquizaminos.Accounts.User

  setup %{conn: conn} do
    user = %User{name: "Quiz Block ", user_id: 40_000_000}
    conn = assign(conn, :current_user, user.user_id)
    [user: user, conn: conn]
  end

  test "respective qna powersups are displayed if questions are answered correctly", %{conn: conn} do
    categories = Quadquizaminos.QnA.categories()
    {view, _html} = pause_game(conn)

    Enum.each(categories, fn category ->
      render_click(view, "choose_category", %{"category" => category})

      right_answer = Quadquizaminos.QnA.question(category).correct
      render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})
    end)

    html = render_keydown(view, "keydown", %{"key" => " "})

    assert html =~ "<i class=\"fas fa-angle-double-right\""
    assert html =~ "<i class=\"fas fa-angle-double-right\""
    assert html =~ "<i class=\"fas fa-plus-square\""
  end

  describe "Addblock" do
    setup %{conn: conn} do
      {view, _html} = pause_game(conn)

      render_click(view, "choose_category", %{"category" => "supply_chain_sample"})

      right_answer = Quadquizaminos.QnA.question("supply_chain_sample").correct
      html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      [html: html, view: view]
    end

    test "powerup is displayed when qna question with addblock powerup is answered correctly", %{
      html: html
    } do
      assert html =~ "<i class=\"fas fa-plus-square\""
    end

    test "powerup when clicked modal disappears", %{view: view} do
      html = render_click(view, "powerup", %{"powerup" => "addblock"})
      refute html =~ "<div class=\"phx-modal-content\">"
    end

    test "powerup provide ability to add block using mouse pointer", %{view: view} do
      render_click(view, "powerup", %{"powerup" => "addblock"})
      html = render_click(view, "add_block", %{"x" => "5", "y" => "20"})

      assert html =~
               "</rect><rect phx-click=\"move_or_delete_block\" phx-value-x=\"5\" phx-value-y=\"20\" phx-value-color=\"purple\""
    end

    test "powerup is depleted once used", %{view: view} do
      render_click(view, "powerup", %{"powerup" => "addblock"})
      render_click(view, "add_block", %{"x" => "5", "y" => "20"})
      html = render_keydown(view, "keydown", %{"key" => " "})

      refute html =~ "<i class=\"fas fa-plus-square\""
    end
  end

  describe "Deleteblock" do
    setup %{conn: conn} do
      {view, _html} = pause_game(conn)

      render_click(view, "choose_category", %{"category" => "open_chain_sample"})

      right_answer = Quadquizaminos.QnA.question("supply_chain_sample").correct
      html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      [html: html, view: view]
    end

    test "powerup is displayed when qna question with deleteblock powerup is answered correctly",
         %{
           html: html
         } do
      assert html =~ "<i class=\"fas fa-minus-square\""
    end

    test "powerup when clicked modal disappears", %{view: view} do
      html = render_click(view, "powerup", %{"powerup" => "addblock"})
      refute html =~ "<div class=\"phx-modal-content\">"
    end

    test "powerup provide ability to delete block", %{view: view} do
      # add block
      render_click(view, "choose_category", %{"category" => "supply_chain_sample"})

      right_answer = Quadquizaminos.QnA.question("supply_chain_sample").correct
      render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      render_click(view, "powerup", %{"powerup" => "addblock"})
      html = render_click(view, "add_block", %{"x" => "5", "y" => "20"})

      assert html =~
               "</rect><rect phx-click=\"move_or_delete_block\" phx-value-x=\"5\" phx-value-y=\"20\" phx-value-color=\"purple\""

      # delete block
      render_click(view, "powerup", %{"powerup" => "deleteblock"})
      html = render_click(view, "move_or_delete_block", %{"x" => "5", "y" => "20"})

      refute html =~
               "</rect><rect phx-click=\"move_or_delete_block\" phx-value-x=\"5\" phx-value-y=\"20\" phx-value-color=\"purple\""
    end

    test "powerup is depleted once used", %{view: view} do
      # add block
      render_click(view, "choose_category", %{"category" => "supply_chain_sample"})

      right_answer = Quadquizaminos.QnA.question("supply_chain_sample").correct
      render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      render_click(view, "powerup", %{"powerup" => "addblock"})
      html = render_click(view, "add_block", %{"x" => "5", "y" => "20"})

      assert html =~
               "</rect><rect phx-click=\"move_or_delete_block\" phx-value-x=\"5\" phx-value-y=\"20\" phx-value-color=\"purple\""

      # delete block
      render_click(view, "powerup", %{"powerup" => "deleteblock"})
      render_click(view, "move_or_delete_block", %{"x" => "5", "y" => "20"})

      html = render_keydown(view, "keydown", %{"key" => " "})

      refute html =~ "<i class=\"fas fa-minus-square\""
    end
  end

  describe "Moveblock" do
    setup %{conn: conn} do
      {view, _html} = pause_game(conn)

      render_click(view, "choose_category", %{"category" => "sbom_sample"})

      right_answer = Quadquizaminos.QnA.question("sbom_sample").correct
      html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      [html: html, view: view]
    end

    test "powerup is displayed when qna question with moveblock powerup is answered correctly", %{
      html: html
    } do
      assert html =~ "<i class=\"fas fa-angle-double-right\""
    end

    test "powerup when clicked modal disappears", %{view: view} do
      html = render_click(view, "powerup", %{"powerup" => "addblock"})
      refute html =~ "<div class=\"phx-modal-content\">"
    end

    test "powerup provide ability to move block", %{view: view} do
      # add block
      render_click(view, "choose_category", %{"category" => "supply_chain_sample"})

      right_answer = Quadquizaminos.QnA.question("supply_chain_sample").correct
      render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      render_click(view, "powerup", %{"powerup" => "addblock"})
      html = render_click(view, "add_block", %{"x" => "5", "y" => "20"})

      assert html =~
               "</rect><rect phx-click=\"move_or_delete_block\" phx-value-x=\"5\" phx-value-y=\"20\" phx-value-color=\"purple\""

      # move block
      render_keydown(view, "keydown", %{"key" => " "})
      render_click(view, "powerup", %{"powerup" => "moveblock"})

      render_click(view, "move_or_delete_block", %{"x" => "5", "y" => "20", "color" => "purple"})
      html = render_click(view, "add_block", %{"x" => "7", "y" => "18"})

      refute html =~
               "</rect><rect phx-click=\"move_or_delete_block\" phx-value-x=\"5\" phx-value-y=\"20\" phx-value-color=\"purple\""

      assert html =~
               "</rect><rect phx-click=\"move_or_delete_block\" phx-value-x=\"7\" phx-value-y=\"18\" phx-value-color=\"purple\""
    end

    test "powerup is depleted once used", %{view: view} do
      # add block
      render_click(view, "choose_category", %{"category" => "supply_chain_sample"})

      right_answer = Quadquizaminos.QnA.question("supply_chain_sample").correct
      render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      render_click(view, "powerup", %{"powerup" => "addblock"})
      html = render_click(view, "add_block", %{"x" => "5", "y" => "20"})

      assert html =~
               "</rect><rect phx-click=\"move_or_delete_block\" phx-value-x=\"5\" phx-value-y=\"20\" phx-value-color=\"purple\""

      # move block
      render_keydown(view, "keydown", %{"key" => " "})
      render_click(view, "powerup", %{"powerup" => "moveblock"})

      render_click(view, "move_or_delete_block", %{"x" => "5", "y" => "20", "color" => "purple"})
      html = render_click(view, "add_block", %{"x" => "7", "y" => "18"})

      refute html =~ "<i class=\"fas fa-angle-double-right\""
    end
  end

  defp pause_game(conn) do
    {:ok, view, _html} = live(conn, "/tetris")

    render_click(view, "start")
    html = render_keydown(view, "keydown", %{"key" => " "})
    {view, html}
  end
end
