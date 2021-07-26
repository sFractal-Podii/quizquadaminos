defmodule QuadquizaminosWeb.ContestFinalResultComponent do
  use QuadquizaminosWeb, :live_component

  def render(assigns) do
    ~L"""
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
end
