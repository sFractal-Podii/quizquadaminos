defmodule QuadquizaminosWeb.LeaderboardLive do
  use Phoenix.LiveView

  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  alias Quadquizaminos.GameBoard.Records
  alias Quadquizaminos.Util

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(paginate_records: Records.fetch_records(1), page: 1)}
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

    <%= for record <- @paginate_records do %>
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
    <%= for i <- (@page - 5)..(@page + 5), i>0 do %>
    <%= live_patch i, to: Routes.live_path(@socket,__MODULE__,page: i)%>
    <% end %>
    </div>
    """
  end

  def handle_event("sort", %{"param" => sort_by}, socket) do
    IO.inspect(sort_by)
    socket = socket |> assign(paginate_records: Records.sort_games(sort_by))
    {:noreply, socket}
  end

  def handle_params(%{"page" => page}, _url, socket) do
    page = String.to_integer(page)
    {:noreply, socket |> assign(page: page, paginate_records: Records.fetch_records(page))}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
