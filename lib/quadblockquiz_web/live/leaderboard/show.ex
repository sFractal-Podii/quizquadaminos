defmodule QuadblockquizWeb.LeaderboardLive.Show do
  use QuadblockquizWeb, :live_view
  import Phoenix.Component

  alias Quadblockquiz.GameBoard.Records

  alias QuadblockquizWeb.SvgBoard

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <div class="row">
        <div class="column column-50">
          {display_bottom(@record.bottom_blocks, assigns)}
        </div>
        <div class="column column-50 column-offset-25">
          <p><b>End game status for {@record.user.name}</b></p>
          <ul>
            <li><b>Score:</b>{@record.score}</li>
            <li><b>Bricks:</b>{@record.dropped_bricks}</li>
            <li><b>Questions:</b>{@record.correctly_answered_qna}</li>
          </ul>
          <.link patch={Routes.live_path(@socket, QuadblockquizWeb.LeaderboardLive)} class="button">
            Back to Leaderboard
          </.link>
        </div>
      </div>
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
    assigns = assign_new(assigns, :bottom_blocks, fn -> bottom_blocks end)

    ~H"""
    {raw(SvgBoard.svg_head())}
    <%= for row <- [bottom_values(@bottom_blocks)] do %>
      <%= for {x, y, color} <- row do %>
        <svg>
          {raw(SvgBoard.box({x, y}, color))}
        </svg>
      <% end %>
    <% end %>
    {raw(SvgBoard.svg_foot())}
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
