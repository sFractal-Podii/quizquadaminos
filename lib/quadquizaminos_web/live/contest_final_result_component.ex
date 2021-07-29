defmodule QuadquizaminosWeb.ContestFinalResultComponent do
  use QuadquizaminosWeb, :live_component

  alias Quadquizaminos.Contests

  def render(assigns) do
    ~L"""
    <h1>Contestboard</h1>
      <table>
      <tr>
      <th>Player</th>
      <th phx-click="sort" phx-value-param="score" phx-target="<%= @myself %>">Score</th>
      <th phx-click="sort" phx-value-param="dropped_bricks" phx-target="<%= @myself %>">Bricks</th>
      <th phx-click="sort" phx-value-param="correctly_answered_qna" phx-target="<%= @myself %>">Questions</th>
      <th>Start time</th>
      <th>End time</th>
      </tr>

      <%= for record <- @contest_records do %>
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
    """
  end

  def handle_event("sort", %{"param" => param}, socket) do
    [record | _] = socket.assigns.contest_records

    contest_records =
      record.contest_id
      |> Contests.get_contest()
      |> Contests.contest_game_records(param)

    {:noreply, assign(socket, contest_records: contest_records)}
  end
end
