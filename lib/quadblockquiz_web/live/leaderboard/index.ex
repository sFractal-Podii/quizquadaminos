defmodule QuadblockquizWeb.LeaderboardLive do
  use Phoenix.LiveView
  import Phoenix.Component

  alias QuadblockquizWeb.Router.Helpers, as: Routes

  alias Quadblockquiz.GameBoard.Records
  alias Quadblockquiz.Util

  @cell_style "border-b border-slate-100 dark:border-slate-700 p-4 pl-8 text-slate-500 dark:text-slate-400"

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       page: 1,
       records: Records.fetch_records(),
       sort_by: "score"
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="md:grid md:items-center md:justify-center md:space-y-12">
      <div class="hidden md:block table w-full">
        <div class="table-caption heading-1">Leaderboard</div>
        <div class=" md:table-header-group md:bg-sky-50 ">
          <div class="table-row">
            <div class="md:table-cell md:p-4">Player</div>
            <div
              class="md:cursor-pointer text-left table-cell md:p-4"
              phx-click="sort"
              phx-value-param="score"
            >
              Score
            </div>
            <div
              class="md:cursor-pointer text-left table-cell md:p-4"
              phx-click="sort"
              phx-value-param="dropped_bricks"
            >
              Bricks
            </div>
            <div
              class="md:cursor-pointer text-left table-cell md:p-4"
              phx-click="sort"
              phx-value-param="correctly_answered_qna"
            >
              Questions
            </div>
            <div class=" text-lef table-cell md:p-4">Powerups(used|available)</div>
            <div class=" text-lef table-cell md:p-4">Start time</div>
            <div class="table-cell text-left md:p-4">End time</div>
            <div class="table-cell text-left  md:p-4">Date</div>
            <div class="table-cell text-left  md:p-4"></div>
          </div>
        </div>
        <div class="md:table-row-group">
          <%= for record <- @records do %>
            <div class="table-row">
              <div class={"table-cell #{cell_style()}"}>{record.user.name}</div>
              <div class={"table-cell #{cell_style()}"}>{record.score}</div>
              <div class={"table-cell #{cell_style()}"}>{record.dropped_bricks}</div>
              <div class={"table-cell #{cell_style()}"}>{record.correctly_answered_qna}</div>
              <div class={"table-cell #{cell_style()}"}>{record.powerups}</div>
              <div class={"table-cell #{cell_style()}"}>
                {Util.datetime_to_time(record.start_time)}
              </div>
              <div class={"table-cell #{cell_style()}"}>
                {Util.datetime_to_time(record.end_time)}
              </div>
              <div class={"table-cell #{cell_style()}"}>
                {Util.datetime_to_date(record.start_time)}
              </div>
              <div class={"table-cell #{cell_style()}"}>
                <a href={Routes.live_path(@socket, QuadblockquizWeb.LeaderboardLive.Show, record)}>
                  <i class="fas fa-chevron-right"></i>
                </a>
              </div>
            </div>
          <% end %>
        </div>
      </div>

      <div class="md:hidden">
        <div class="table-caption heading-1">Leaderboard</div>
        <%= for record <- @records do %>
          <div class="rounded-lg shadow">
            <ul class="list-decimal py-4 pl-4">
              <a href={Routes.live_path(@socket, QuadblockquizWeb.LeaderboardLive.Show, record)}>
                <li class="inline-flex">
                  {user_avatar(record.user.avatar, assigns)}
                  <div class="grid grid-cols-2 gap-x-44 pt-2 px-4">
                    <div class="grid w-48">
                      <p class="text-base font-sans tracking-wide">{record.user.name}</p>
                      <p class="text-gray-400 text-sm">
                        {time_taken(record.start_time, record.end_time)}
                      </p>
                    </div>
                    <p class="tracking-wide text-base font-sans font-bold">{record.score}</p>
                  </div>
                </li>
              </a>
            </ul>
          </div>
        <% end %>
      </div>

      <div class="hidden md:flex md:items-center md:justify-center md:gap-x-2">
        <%= for i <- (@page - 5)..(@page + 5), i>0 do %>
          <div class="md:border md:border-blue-600 md:p-2 md:rounded">
            <.link
              patch={Routes.live_path(@socket, __MODULE__, page: i, sort_by: @sort_by)}
              class="button button-outline"
            >
              {i}
            </.link>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp cell_style do
    @cell_style
  end

  defp time_taken(start_time, end_time) when is_nil(start_time) or is_nil(end_time) do
    "playing"
  end

  defp time_taken(start_time, end_time) do
    "#{DateTime.diff(end_time, start_time)} sec"
  end

  defp user_avatar(nil, assigns) do
    ~H"""
    <img
      class="border-2 border-blue-600 rounded-full h-12 w-12 flex items-center justify-center "
      src={Routes.static_path(QuadblockquizWeb.Endpoint, "/images/user-avatar.jpeg")}
      alt="user avatar"
    />
    """
  end

  defp user_avatar(avatar, assigns) do
    assigns = assign_new(assigns, :avatar, fn -> avatar end)

    ~H"""
    <img
      class="border-2 border-blue-600 rounded-full h-12 w-12 flex items-center justify-center "
      src={@avatar}
    />
    """
  end

  def handle_event("sort", %{"param" => sort_by}, socket) do
    socket = socket |> assign(sort_by: sort_by)

    {:noreply,
     push_patch(socket, to: Routes.live_path(socket, __MODULE__, sort_by: sort_by, page: 1))}
  end

  def handle_params(%{"page" => page, "sort_by" => sorter}, _url, socket) do
    page = String.to_integer(page)
    {:noreply, socket |> assign(page: page, records: Records.fetch_records(page, sorter))}
  end

  def handle_params(%{"page" => page}, _url, socket) do
    page = String.to_integer(page)
    {:noreply, socket |> assign(page: page, records: Records.fetch_records(page))}
  end

  def handle_params(%{"sort_by" => sort_by}, _url, socket) do
    {:noreply, socket |> assign(page: 1, records: Records.fetch_records(1, sort_by))}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
