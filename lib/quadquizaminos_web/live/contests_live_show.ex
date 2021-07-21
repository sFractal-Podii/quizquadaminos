defmodule QuadquizaminosWeb.ContestsLive.Show do
  use QuadquizaminosWeb, :live_view

  alias Quadquizaminos.Contests

  def render(assigns) do
    ~L"""
    <div class="container">
     <h1>Contestboard</h1>
     <table>
     <tr>
     <th>Player</th>
     <th>Score</th>
     <th>Bricks</th>
     <th>Questions</th>
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
        Contests.contest_game_records(contest)
    end
  end
end
