defmodule QuadquizaminosWeb.ContestsLive.Show do
  use QuadquizaminosWeb, :live_view

  alias Quadquizaminos.Contests
  alias Quadquizaminos.GameBoard.Records

  def render(assigns) do
    ~L"""
    <div class="container">
     <h1>Contestboard</h1>
     <table>
     <tr>
     <th>Player</th>
     <th phx-click="sort" phx-value-param="score">Score</th>
     <th phx-click="sort" phx-value-param="dropped_bricks">Bricks</th>
     <th phx-click="sort" phx-value-param="correctly_answered_qna">Questions</th>
     <th>Start time</th>
     <th>End time</th>
     </tr>

     <%= for record <- @contest_record do %>
      <tr>
     <td><%= record.user.name %></td>
     <td><%= record.score %></td>
     <td><%= record.dropped_bricks %></td>
     <td><%= record.correctly_answered_qna %></td>
     <td><%= DateTime.truncate(record.start_time, :second) %></td>
     <td><%= DateTime.truncate(record.end_time, :second) %></td>

     </tr>
     <% end %>
     </table>
     </div>
    """
  end

  def handle_params(%{"contest_id" => contest_id}, _uri, socket) do
    {:noreply, assign(socket, contest_record: contest_records(contest_id))}
  end

  defp contest_records(contest_id) do
    case String.to_integer(contest_id) |> Contests.get_contest() do
      nil ->
        []

      contest ->
        contest_record =
          contest.start_time
          |> Records.contest_game(contest.end_time, contest_id)
    end
  end

  # def handle_event("sort", %{"param" => param}, socket) do
  #   socket = socket |> assign(contest_record: Records.top_10_games(param))
  #   {:noreply, socket}
  # end
end
