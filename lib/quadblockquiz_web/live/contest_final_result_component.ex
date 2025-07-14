defmodule QuadblockquizWeb.ContestFinalResultComponent do
  use QuadblockquizWeb, :live_component
  import Phoenix.Component

  alias Quadblockquiz.Contests

  def render(assigns) do
    ~H"""
    <div>
      <h1>Contestboard for {@contest.name}</h1>
      <%= if @contest_records == []  do %>
        <h2>No records for this contest</h2>
        <.link patch={Routes.contests_path(@socket, :index)} class="button button-outline">
          Back to contest listing
        </.link>
      <% else %>
        <table>
          <tr>
            <th>Player</th>
            <th class="pointer" phx-click="sort" phx-value-param="score" phx-target={@myself}>
              Score
            </th>
            <th class="pointer" phx-click="sort" phx-value-param="dropped_bricks" phx-target={@myself}>
              Bricks
            </th>
            <th
              class="pointer"
              phx-click="sort"
              phx-value-param="correctly_answered_qna"
              phx-target={@myself}
            >
              Questions
            </th>
            <th>Start time</th>
            <th>End time</th>
          </tr>

          <%= for record <- @contest_records do %>
            <tr>
              <td>
                <%= unless record.end_time do %>
                  <svg height="10" width="10">
                    <circle cx="5" cy="5" r="5" fill="green" /> Playing
                  </svg>
                <% end %>
                {user_name(record)}
              </td>
              <td align="right">{record.score}</td>
              <td align="center">{record.dropped_bricks}</td>
              <td align="center">{record.correctly_answered_qna}</td>
              <td>{truncate_date(record.start_time)}</td>
              <td>{truncate_date(record.end_time)}</td>
            </tr>
          <% end %>
        </table>
        <%= unless active_contest?(@contest.name) do %>
          <%= for i <- (@page - 5)..(@page + 5), i >0 do %>
            <.link
              patch={Routes.contests_path(@socket, :show, @contest, page: i, sort_by: @sort_by)}
              class="button button-outline"
            >
              {i}
            </.link>
          <% end %>
        <% end %>
      <% end %>
      <!-- end else for checking records -->
    </div>
    """
  end

  def update(assigns, socket) do
    records =
      if active_contest?(assigns.contest.name) do
        (assigns.contest_records ++ Contests.contest_game_records(assigns.contest))
        |> Enum.sort_by(& &1.score, :desc)
        |> Enum.uniq_by(fn %{score: score, uid: uid, dropped_bricks: bricks} ->
          %{score: score, uid: uid, dropped_bricks: bricks}
        end)
      else
        Contests.contest_game_records(assigns.contest, assigns.page, assigns.sort_by)
      end

    {:ok,
     assign(socket,
       contest_records: records,
       contest: assigns.contest,
       page: assigns[:page],
       sort_by: assigns[:sort_by]
     )}
  end

  def handle_event("sort", %{"param" => sort_by}, socket) do
    contest = socket.assigns.contest

    socket = socket |> assign(sort_by: sort_by)

    params = [sort_by: sort_by]

    {:noreply,
     socket
     |> push_patch(
       to:
         Routes.contests_path(
           socket,
           :show,
           contest,
           if(active_contest?(contest.name), do: params, else: params ++ [page: 1])
         )
     )}
  end

  def truncate_date(nil) do
    nil
  end

  def truncate_date(date) do
    DateTime.truncate(date, :second)
  end

  defp active_contest?(name) do
    name = String.to_atom(name)
    :ets.whereis(name) != :undefined
  end

  defp user_name(record) do
    case record do
      %Quadblockquiz.GameBoard{} ->
        record.user.name

      _ ->
        case Quadblockquiz.Accounts.get_user(record.uid) do
          nil -> "Anonymous"
          user -> user.name
        end
    end
  end
end
