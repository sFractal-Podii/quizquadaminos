defmodule QuadquizaminosWeb.LeaderboardLive do
  use Phoenix.LiveView

  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  alias Quadquizaminos.GameBoard.Records
  alias Quadquizaminos.Util

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(page: 1, records: Records.fetch_records(), sort_by: "score")}
  end

  def render(assigns) do
    ~L"""
    <div class="md:grid md:items-center md:justify-center md:space-y-12">
      <div class="table">
        <div class="table-caption heading-1">Leaderboard</div>
        <div class="hidden md:table-header-group md:bg-sky-50 ">
          <div class="md:table-cell md:p-4">Player</div>
          <div class="md:cursor-pointer md:table-cell md:p-4" phx-click="sort" phx-value-param="score">Score</div>
          <div class="md:cursor-pointer md:table-cell md:p-4" phx-click="sort" phx-value-param="dropped_bricks">Bricks</div>
          <div class="md:cursor-pointer md:table-cell md:p-4" phx-click="sort" phx-value-param="correctly_answered_qna">Questions</div>
          <div class="md:table-cell md:p-4">Start time</div>
          <div class="md:table-cell md:p-4">End time</div>
          <div class="md:table-cell md:p-4">Date</div>
          <div class="md:table-cell md:p-4"></div>
        </div>
        <%= for record <- @records do %>
        <div class="hidden md:table-row-group">
          <div class="md:table-row ">
            <div class="table-cell md:p-4"><%= record.user.name %></div>
            <div class="table-cell md:p-4"><%= record.score %></div>
            <div class="table-cell md:p-4"><%= record.dropped_bricks %></div>
            <div class="table-cell md:p-4"><%= record.correctly_answered_qna %></div>
            <div class="table-cell md:p-4"><%= Util.datetime_to_time(record.start_time) %></div>
            <div class="table-cell md:p-4"><%= Util.datetime_to_time(record.end_time) %></div>
            <div class="table-cell md:p-4"><%= Util.datetime_to_date(record.start_time) %></div>
            <div class="table-cell md:p-4"><a href="<%= Routes.live_path(@socket, QuadquizaminosWeb.LeaderboardLive.Show, record) %>"><i class="fas fa-chevron-right"></i></a></div>
          </div>
        </div>
         <div class="rounded-lg shadow md:hidden">
           <ul class="list-decimal py-4 pl-4">
             <li class="inline-flex">
               <%= user_avatar(record.user.avatar, assigns) %>
               <div class="flex justify-between pt-2 space-x-40 px-4">
                 <div class="flex flex-col">
                   <p class="text-base font-sans tracking-wide"><%= record.user.name %></p>
                   <p class="text-gray-400 text-sm"><%= DateTime.diff(record.end_time, record.start_time)%> sec</p>
                 </div>
                 <p class="tracking-wide text-base font-sans font-bold"><%= record.score %></p>
               </div>
             </li>
           </ul>
         </div> 
        <% end %>
      </div>
      <div class="hidden md:flex md:items-center md:justify-center">
        <%= for i <- (@page - 5)..(@page + 5), i>0 do %>
          <div class="md:border md:border-blue-600 md:p-4">
            <%= live_patch i, class: "button button-outline",  to: Routes.live_path(@socket,__MODULE__,page: i, sort_by: @sort_by), id: "goto-#{i}" %>
         </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp user_avatar(nil, assigns) do
    ~L"""
      <img class="border-2 border-blue-600 rounded-full h-12 w-12 flex items-center justify-center " src="<%= Routes.static_path(QuadquizaminosWeb.Endpoint, "/images/user-avatar.jpeg") %>" alt="user avatar" />
    """
  end

  defp user_avatar(avatar, assigns) do
    ~L"""
     <img class="border-2 border-blue-600 rounded-full h-12 w-12 flex items-center justify-center " src="<%= avatar %>" />
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
