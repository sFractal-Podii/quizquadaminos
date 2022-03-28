defmodule QuadblockquizWeb.LeaderboardLive.Show do
  use QuadblockquizWeb, :live_view

  alias Quadblockquiz.GameBoard.Records

  alias QuadblockquizWeb.SvgBoard

  alias QuadblockquizWeb.LeaderboardLive

  @impl true
  def render(assigns) do
    ~L"""
    <div class="grid grid-cols-1 place-items-center mt-6 md:grid-cols-3 md:place-items-start md:mt-12">
    <div class = "mb-6"><%= live_patch "Back to Leaderboard", class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded", to: Routes.live_path(@socket, QuadblockquizWeb.LeaderboardLive) %></div>
    <div><%= display_bottom(@record.bottom_blocks, assigns) %></div>
    <div class = "invisible md:visible">
    <ul>
    <li><b>Score:</b><%= @record.score  %></li>
    <li><b>Bricks:</b><%= @record.dropped_bricks %></li>
    <li><b>Questions:</b><%= @record.correctly_answered_qna %></li>
    </ul>
    </div>

    <div class="rounded-lg shadow md:hidden">
    <br><ul class="list-decimal py-4 pl-4">
             <li class="inline-flex">
               <%= LeaderboardLive.user_avatar(@record.user.avatar, assigns) %>
               <div class="grid grid-cols-2">
                 <div class="grid w-48">
                   <p class="text-base font-sans tracking-wide"><%= @record.user.name %></p>
                   <p class="text-gray-400 text-sm"><%= LeaderboardLive.time_taken(@record.start_time, @record.end_time)%></p>
                 </div>
                 <p class="tracking-wide text-base font-sans font-bold"><%= @record.score %></p>
               </div>
             </li>
           </ul>
         </div>
    """
  end

  @impl true
  def handle_params(%{"board_id" => board_id}, _uri, socket) do
    {:noreply, socket |> assign(record: Records.get_game!(board_id))}
  end

  def display_bottom(nil = _bottom_blocks, _assigns) do
    ""
  end

  def display_bottom(bottom_blocks, assigns) do
    ~L"""
    <%= raw SvgBoard.svg_head() %>
      <%= for row <- [bottom_values(bottom_blocks)] do %>
        <%= for {x, y, color} <- row do %>
         <svg>
          <%= raw SvgBoard.box({x, y}, color)%>
            </svg>
        <% end %>
      <% end %>
        <%= raw SvgBoard.svg_foot() %>
    """
  end

  defp bottom_values(bottom_block) do
    bottom_block
    |> Enum.into(%{}, fn {key, value} ->
      {binary_to_tuple(key), _value(key, value)}
    end)
    |> Map.values()
  end

  defp binary_to_tuple(value) do
    value
    |> :binary.bin_to_list()
    |> List.to_tuple()
  end

  defp _value(key, value) do
    {x, y} = binary_to_tuple(key)
    value = :binary.bin_to_list(value)
    color = (value -- [x, y]) |> :binary.list_to_bin() |> String.to_atom()
    {x, y, color}
  end
end
