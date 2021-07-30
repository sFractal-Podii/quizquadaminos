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

  defp user_name(%Quadquizaminos.Accounts.User{} = user, _uid), do: user.name
end
