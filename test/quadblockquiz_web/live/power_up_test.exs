defmodule QuadblockquizWeb.PowerUpTest do
  use QuadblockquizWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Quadblockquiz.Test.Auth

  @purple_shade %{light: "ff00ff", dark: "800080"}

  setup do
    conn = Auth.login()

    [conn: conn]
  end

  describe "powerup display" do
    setup %{conn: conn} do
      categories = Quadblockquiz.QnA.categories()
      {view, _html} = pause_game(conn)

      html =
        Enum.map_join(categories, fn category ->
          render_click(view, "choose_category", %{"category" => category})
          right_answer = Quadblockquiz.QnA.question(["qna"], category).correct
          render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})
        end)

      [html: html]
    end

    test "powerup hover display name of respective powerups", %{html: html} do
      assert html =~ "class=\"fab fa-superpowers\" title=\"superpower\""
      assert html =~ "class=\"fas fa-file-contract\" title=\"cyberinsurance\""
      assert html =~ "class=\"fas fa-wrench\" title=\"fixvuln\""
    end

    test "respective qna powersups are displayed if questions are answered correctly", %{
      html: html
    } do
      assert html =~ "i class=\"fas fa-file-contract\""
      assert html =~ "<i class=\"fab fa-superpowers\""
      assert html =~ "<i class=\"fas fa-wrench\""
    end

    test "powers don't display on questions that don't have them if answered correctly", %{
      conn: conn
    } do
      {view, _html} = pause_game(conn)

      Enum.each(["open_c2"], fn category ->
        render_click(view, "choose_category", %{"category" => category})
        right_answer = Quadblockquiz.QnA.question(["qna"], category).correct
        render_click(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})
      end)

      html = render_keydown(view, "keydown", %{"key" => " "})
      refute html =~ "<i class=\"fas fa-arrows-alt\""
      refute html =~ "<i class=\"fas fa-plus-square\""
    end
  end

  describe "Addblock" do
    setup %{conn: conn} do
      {view, _html} = pause_game(conn)

      render_click(view, "choose_category", %{"category" => "supply_chain"})
      right_answer = Quadblockquiz.QnA.question(["qna"], "supply_chain").correct
      html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      [html: html, view: view]
    end

    test "powerup when clicked modal disappears", %{view: view} do
      html = render_click(view, "powerup", %{"powerup" => "addblock"})
      refute html =~ "<div class=\"phx-modal-content\">"
    end

    test "powerup provide ability to add block using mouse pointer", %{view: view} do
      render_click(view, "powerup", %{"powerup" => "addblock"})
      html = render_click(view, "add_block", %{"x" => "5", "y" => "20"})

      assert html =~
               "<svg phx-click=\"transform_block\" phx-value-x=\"5\" phx-value-y=\"20\" phx-value-color=\"purple\">"

      assert html =~ @purple_shade.light
      assert html =~ @purple_shade.dark
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

      render_click(view, "choose_category", %{"category" => "open_chain"})
      right_answer = Quadblockquiz.QnA.question(["qna"], "open_chain").correct
      html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      [html: html, view: view]
    end

    test "powerup when clicked modal disappears", %{view: view} do
      html = render_click(view, "powerup", %{"powerup" => "deleteblock"})
      refute html =~ "<div class=\"phx-modal-content\">"
    end

    test "powerup provide ability to delete block", %{view: view} do
      # add block
      html = add_block(view)

      assert html =~
               "<svg phx-click=\"transform_block\" phx-value-x=\"5\" phx-value-y=\"20\" phx-value-color=\"purple\">"

      # delete block
      render_click(view, "powerup", %{"powerup" => "deleteblock"})
      html = render_click(view, "transform_block", %{"x" => "5", "y" => "20"})

      refute html =~
               "<svg phx-click=\"transform_block\" phx-value-x=\"5\" phx-value-y=\"20\" phx-value-color=\"purple\">"

      refute html =~ @purple_shade.light
      refute html =~ @purple_shade.dark
    end

    test "powerup is depleted once used", %{view: view} do
      # add block
      add_block(view)
      # delete block
      render_click(view, "powerup", %{"powerup" => "deleteblock"})
      render_click(view, "transform_block", %{"x" => "5", "y" => "20"})

      html = render_keydown(view, "keydown", %{"key" => " "})

      refute html =~ "<i class=\"fas fa-minus-square\""
    end
  end

  describe "Moveblock" do
    setup %{conn: conn} do
      {view, _html} = pause_game(conn)

      render_click(view, "choose_category", %{"category" => "sbom"})
      right_answer = Quadblockquiz.QnA.question(["qna"], "sbom").correct
      html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      [html: html, view: view]
    end

    test "powerup when clicked modal disappears", %{view: view} do
      html = render_click(view, "powerup", %{"powerup" => "moveblock"})
      refute html =~ "<div class=\"phx-modal-content\">"
    end

    test "powerup provide ability to move block", %{view: view} do
      # add block
      html = add_block(view)

      assert html =~
               "<svg phx-click=\"transform_block\" phx-value-x=\"5\" phx-value-y=\"20\" phx-value-color=\"purple\">"

      # move block
      render_keydown(view, "keydown", %{"key" => " "})
      render_click(view, "powerup", %{"powerup" => "moveblock"})

      render_click(view, "transform_block", %{"x" => "5", "y" => "20", "color" => "purple"})
      html = render_click(view, "add_block", %{"x" => "7", "y" => "20"})

      refute html =~
               "<svg phx-click=\"transform_block\" phx-value-x=\"5\" phx-value-y=\"20\" phx-value-color=\"purple\">"

      assert html =~
               "<svg phx-click=\"transform_block\" phx-value-x=\"7\" phx-value-y=\"20\" phx-value-color=\"purple\">"
    end

    test "powerup is depleted once used", %{view: view} do
      # add block
      add_block(view)

      # move block
      render_keydown(view, "keydown", %{"key" => " "})
      render_click(view, "powerup", %{"powerup" => "moveblock"})

      render_click(view, "transform_block", %{"x" => "5", "y" => "20", "color" => "purple"})
      render_click(view, "add_block", %{"x" => "7", "y" => "20"})

      html = render_keydown(view, "keydown", %{"key" => " "})

      refute html =~ "<i class=\"fas fa-arrows-alt\""
    end
  end

  describe "Fixvuln single block" do
    setup %{conn: conn} do
      {view, _html} = pause_game(conn)

      render_click(view, "choose_category", %{"category" => "phoenix"})
      right_answer = Quadblockquiz.QnA.question(["qna"], "phoenix").correct
      html = render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

      [html: html, view: view, oc_right_answer: right_answer]
    end

    test "powerup when clicked modal disappears", %{view: view} do
      html = render_click(view, "powerup", %{"powerup" => "fixvuln"})
      refute html =~ "<div class=\"phx-modal-content\">"
    end
  end

  defp pause_game(conn) do
    {:ok, view, _html} = live(conn, "/tetris")

    render_click(view, "start", %{contest: ""})
    html = render_keydown(view, "keydown", %{"key" => " "})
    {view, html}
  end

  defp add_block(view, x \\ "5", y \\ "20") do
    render_click(view, "choose_category", %{"category" => "supply_chain"})

    right_answer = Quadblockquiz.QnA.question(["qna"], "supply_chain").correct

    render_submit(view, "check_answer", %{"quiz" => %{"guess" => right_answer}})

    render_click(view, "powerup", %{"powerup" => "addblock"})
    render_click(view, "add_block", %{"x" => x, "y" => y})
  end
end
