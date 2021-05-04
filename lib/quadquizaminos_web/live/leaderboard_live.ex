defmodule QuadquizaminosWeb.LeaderboardLive do
  use Phoenix.LiveView

  alias Quadquizaminos.GameBoard.Records

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
    <th>Score</th>
    <th>Dropped Bricks</th>
    <th>Correctly Answered Qna</th>
    <th>Start time</th>
    <th>End time</th>
    <th>Date</th>
    </tr>

    <%= for record <- @top_10_games do %>
     <tr>
    <td><%= record.user.name %></td>
    <td><%= record.score %></td>
    <td><%= record.dropped_bricks %></td>
    <td><%= record.correctly_answered_qna %></td>
    <td><%= datetime_to_time(record.start_time) %></td>
    <td><%= datetime_to_time(record.end_time) %></td>
    <td><%= datetime_to_date(record.start_time) %></td>
    </tr>
    <% end %>

    </table>
    </div>
    """
  end

  defp datetime_to_time(datetime) do
    datetime
    |> DateTime.truncate(:second)
    |> DateTime.to_time()
  end

  defp datetime_to_date(datetime) do
    datetime
    |> DateTime.to_date()
  end
end
