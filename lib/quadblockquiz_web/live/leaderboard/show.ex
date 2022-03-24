defmodule QuadblockquizWeb.LeaderboardLive.Show do
  use QuadblockquizWeb, :live_view

  alias Quadblockquiz.GameBoard.Records

  alias QuadblockquizWeb.SvgBoard

  @impl true
  def render(assigns) do
    ~L"""
    <div class="grid grid-cols-1 md:grid-cols-3 md:mt-12">
    <div><%= live_patch "Back to Leaderboard", class: "button", to: Routes.live_path(@socket, QuadblockquizWeb.LeaderboardLive) %></div>
    <div><%= display_bottom(@record.bottom_blocks, assigns) %></div>
    <div>
    <ul>
    <li><b>Score:</b><%= @record.score  %></li>
    <li><b>Bricks:</b><%= @record.dropped_bricks %></li>
    <li><b>Questions:</b><%= @record.correctly_answered_qna %></li>
    </ul>
    </div>

    <table class="table-auto mt-6">
    <tr>
    <%= @record.user.name %>
    <td>
    <%= @record.score  %>
    </td>
    </tr>
    </table>

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
