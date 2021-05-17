defmodule QuadquizaminosWeb.LeaderboardLive do
  use Phoenix.LiveView

  import QuadquizaminosWeb.LiveHelpers
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  alias Quadquizaminos.GameBoard.Records
  alias Quadquizaminos.Util

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(top_10_games: Records.top_10_games())}
  end

  def render(assigns) do
    ~L"""
    <div class="container">
    <h1>Leaderboard</h1>
    <table>
    <tr>
    <th>Player</th>
    <th phx-click="sort" phx-value-param="score">Score</th>
    <th phx-click="sort" phx-value-param="dropped_bricks">Bricks</th>
    <th phx-click="sort" phx-value-param="correctly_answered_qna">Questions</th>
    <th>Start time</th>
    <th>End time</th>
    <th>Date</th>
    <th>Tetris board</th>
    </tr>

    <%= for record <- @top_10_games do %>
     <tr>
    <td><%= record.user.name %></td>
    <td><%= record.score %></td>
    <td><%= record.dropped_bricks %></td>
    <td><%= record.correctly_answered_qna %></td>
    <td><%= Util.datetime_to_time(record.start_time) %></td>
    <td><%= Util.datetime_to_time(record.end_time) %></td>
    <td><%= Util.datetime_to_date(record.start_time) %></td>
    <td><%= live_redirect "view", to: Routes.live_path(@socket, QuadquizaminosWeb.LeaderboardLive.Show, record)%></td>
    </tr>
    <% end %>
    </table>
    </div>
    """
  end

  def handle_event("sort", %{"param" => param}, socket) do
    socket = socket |> assign(top_10_games: Records.top_10_games(param))
    {:noreply, socket}
  end
end
