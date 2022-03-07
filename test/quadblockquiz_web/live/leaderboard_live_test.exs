defmodule QuadblockquizWeb.LeaderboardLiveTest do
  use QuadblockquizWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Quadblockquiz.Accounts
  alias Quadblockquiz.Accounts.User
  alias Quadblockquiz.GameBoard.Records

  test "users can access leaderboard", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/leaderboard")

    assert html =~ "<h1>Leaderboard</h1>"
  end

  ## This test should propabably go since we are already testing rendering of
  ## 25 records at a time which is what the current implementation does
  test "top 10 games played are displayed", %{conn: conn} do
    Enum.each(1..15, fn num ->
      attrs = %{name: "Quiz Block ", uid: Integer.to_string(num), role: "player"}
      {:ok, user} = Accounts.create_user(%User{}, attrs)

      game_record = %{
        start_time: ~U[2021-04-20 06:00:53Z],
        end_time: DateTime.utc_now(),
        uid: user.uid,
        score: 10 * num,
        dropped_bricks: 10,
        correctly_answered_qna: 2
      }

      Records.record_player_game(true, game_record)
    end)

    {:ok, _view, html} = live(conn, "/leaderboard")
    assert row_count(html) == 15
    assert html =~ "<th>Player</th>"
    assert html =~ "<th>Start time</th>"
    assert html =~ "<th>End time</th>"
    assert html =~ "<th>Date</th>"
  end

  test "user can be redicted to view player bottom blocks ", %{conn: conn} do
    bottom = %{
      <<1, 20>> => <<1, 20, 112, 105, 110, 107>>,
      <<1, 19>> => <<1, 19, 112, 105, 110, 107>>,
      <<1, 18>> => <<1, 18, 112, 105, 110, 107>>,
      <<1, 17>> => <<1, 17, 112, 105, 110, 107>>
    }

    attrs = %{name: "Quiz Block ", uid: "100", role: "player"}
    {:ok, user} = Accounts.create_user(%User{}, attrs)

    game_record = %{
      start_time: ~U[2021-04-20 06:00:53Z],
      end_time: DateTime.utc_now(),
      uid: user.uid,
      score: 100,
      dropped_bricks: 10,
      correctly_answered_qna: 2,
      bottom_blocks: bottom
    }

    {:ok, record} = Records.record_player_game(true, game_record)
    {:ok, _view, html} = live(conn, "/leaderboard/#{record.id}")
    assert html =~ "<p><b>End game status for Quiz Block </b>"
  end

  describe "pagination" do
    setup do
      max = 97

      1..max
      |> Enum.each(fn num ->
        bottom = %{
          <<1, 20>> => <<1, 20, 112, 105, 110, 107>>,
          <<1, 19>> => <<1, 19, 112, 105, 110, 107>>,
          <<1, 18>> => <<1, 18, 112, 105, 110, 107>>,
          <<1, 17>> => <<1, 17, 112, 105, 110, 107>>
        }

        attrs = %{name: "Quiz Block ", uid: "#{num}", role: "player"}
        {:ok, user} = Accounts.create_user(%User{}, attrs)

        game_record = %{
          start_time: ~U[2021-04-20 06:00:53Z],
          end_time: DateTime.utc_now(),
          uid: user.uid,
          score: num,
          dropped_bricks: max + 1 - num,
          correctly_answered_qna: 2,
          bottom_blocks: bottom
        }

        {:ok, _record} = Records.record_player_game(true, game_record)
      end)
    end

    test "renders 25 records at a time", %{conn: conn} do
      Enum.each(1..3, fn page ->
        {:ok, _view, html} = live(conn, "/leaderboard?page=#{page}")

        assert 25 == row_count(html)
      end)
    end

    test "last page contains less records (22)", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/leaderboard?page=4")

      assert 22 == row_count(html)
    end

    test "can navigate to next page", %{conn: conn} do
      {:ok, view, html} = live(conn, "/leaderboard")
      assert html =~ "<td class=\"score\">97</td>"

      html = view |> element("a[href='/leaderboard?page=2&sort_by=score']") |> render_click()
      refute html =~ "<td class=\"score\">97</td>"
    end

    test "maintains sort order", %{conn: conn} do
      {:ok, view, html} = live(conn, "/leaderboard")
      assert html =~ "<td class=\"score\">97</td><td>1</td>"

      html = render_click(view, "sort", %{param: "dropped_bricks"})
      assert html =~ "<td class=\"score\">1</td><td>97</td>"

      html =
        view |> element("a[href='/leaderboard?page=2&sort_by=dropped_bricks']") |> render_click()

      assert html =~ "<td class=\"score\">26</td><td>72</td>"
      refute html =~ "<td class=\"score\">1</td><td>97</td>"
    end

    test "new sort order returns you to page 1", %{conn: conn} do
      {:ok, view, html} = live(conn, "/leaderboard")
      assert html =~ "<td class=\"score\">97</td><td>1</td>"

      html = view |> element("a[href='/leaderboard?page=2&sort_by=score']") |> render_click()
      assert html =~ "<td class=\"score\">72</td><td>26</td>"
      assert html =~ "href=\"/leaderboard?page=7&amp;sort_by=score\""
      html = render_click(view, "sort", %{param: "dropped_bricks"})
      assert html =~ "<td class=\"score\">1</td><td>97</td>"
      refute html =~ "href=\"/leaderboard?page=7&amp;sort_by=dropped_bricks\""
    end
  end

  defp row_count(html) do
    row =
      ~r/<tr>/
      |> Regex.scan(html)
      |> Enum.count()

    # row is deducted by 2 due to the <tr> for table head and also <tr> for footer
    row - 2
  end
end
