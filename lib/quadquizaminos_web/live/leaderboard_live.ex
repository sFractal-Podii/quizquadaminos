defmodule QuadquizaminosWeb.LeaderboardLive do
  use Phoenix.LiveView

  import QuadquizaminosWeb.LiveHelpers
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  alias Quadquizaminos.GameBoard.Records

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(top_10_games: Records.top_10_games(), view_board: false)}
  end

  def render(assigns) do
    ~L"""
    <div class="container">
    <h1>Leaderboard</h1>
    <table>
    <%= unless @view_board do %>
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
    <% end %>

    <%= for record <- @top_10_games do %>
     <tr>
     <%= unless @view_board do %>
    <td><%= record.user.name %></td>
    <td><%= record.score %></td>
    <td><%= record.dropped_bricks %></td>
    <td><%= record.correctly_answered_qna %></td>
    <td><%= datetime_to_time(record.start_time) %></td>
    <td><%= datetime_to_time(record.end_time) %></td>
    <td><%= datetime_to_date(record.start_time) %></td>
    <td><a phx-click="view_board">view</a></td>
    <% end %>
    <td>
     <%= if @view_board do %>
    <%= live_component @socket, QuadquizaminosWeb.TetrisBoardComponent, record: record, bottom_block: record.bottom_blocks, id: record.id %>
     <% end %>
     </td>
    </tr>
    <% end %>
    </table>
    </div>
    """
  end

  def convert(value) do
    value
    |> Enum.map(fn k -> Tuple.to_list(k) end)
  end

  def handle_event("view_board", params, socket) do
    IO.inspect(params)
    {:noreply, socket |> assign(view_board: true)}
  end

  def handle_event("sort", %{"param" => param}, socket) do
    socket = socket |> assign(top_10_games: Records.top_10_games(param))
    {:noreply, socket}
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
