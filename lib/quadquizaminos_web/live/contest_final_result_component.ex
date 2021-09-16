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
      <%= for i <- (@page - 5)..(@page + 5), i >0 do %>
      <%= live_patch i, class: "button button-outline", to: Routes.contests_path(@socket, :show, @contest, page: i)%>
       <% end %>
    """
  end

  def update(assigns, socket) do
    contest_name = String.to_atom(assigns.contest.name)

    records =
      if :ets.whereis(contest_name) != :undefined do
        assigns.contest_records
      else
        Contests.contest_game_records(assigns.contest, assigns.page)
      end

    {:ok, assign(socket, contest_records: records, contest: assigns.contest, page: assigns.page)}
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
