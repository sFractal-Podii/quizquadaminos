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
      <td><%= user_name(record) %></td>
      <td><%= record.score %></td>
      <td><%= record.dropped_bricks %></td>
      <td><%= record.correctly_answered_qna %></td>
      <td><%= truncate_date(record.start_time) %></td>
      <td><%= truncate_date(record.end_time) %></td>

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

  def truncate_date(nil) do
    nil
  end

  def truncate_date(date) do
    DateTime.truncate(date, :second)
  end

  defp user_name(record) do
    case record do
      %Quadquizaminos.GameBoard{} ->
        record.user.name

      _ ->
        case Quadquizaminos.Accounts.get_user(record.uid) do
          nil -> "Anonymous"
          user -> user.name
        end
    end
  end
end
