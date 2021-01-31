defmodule QuadquizaminosWeb.TetrisLive do
  use QuadquizaminosWeb, :live_view

  import Phoenix.HTML, only: [raw: 1]
  alias Quadquizaminos.Tetromino
  alias Quadquizaminos.Point

  @box_width 20
  @box_height 20

  def mount(_params, _session, socket) do
    {:ok, new_game(socket)}
  end

  def render(assigns) do
    ~L"""
      
       <div>
       <%= raw svg_head() %>
       	<%= raw boxes(@tetromino) %>
       	<%= raw svg_foot() %>
       </div>

    """
  end

  defp new_game(socket) do
    socket |> assign(state: :playing, score: 0) |> new_block() |> show()
  end

  def new_block(socket) do
    brick = Tetromino.new_random() |> Map.put(:location, {3, 1})

    assign(socket, brick: brick)
  end

  def show(socket) do
    brick = socket.assigns.brick

    assign(socket,
      tetromino:
        brick
        |> Tetromino.prepare()
        |> Point.with_color(colors(brick))
    )
  end

  def svg_head do
    """
      <svg 
    version="1.0" 
    id="Layer_1"
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    width="200" height="400"
    viewBox="0 0 200 400"
    xml:space="preserve" >

    """
  end

  def svg_foot, do: "</svg>"

  def boxes(points_with_color) do
    points_with_color
    |> Enum.map(fn {x, y, color} ->
      box({x, y}, color)
    end)
    |> Enum.join("\n")
  end

  def box(point, color) do
    """
      #{square(point, shades(color).light)}
      #{triangle(point, shades(color).dark)}
    """
  end

  def square(point, shade) do
    {x, y} = to_pixels(point)

    """
    <rect 
     x="#{x + 1}" y="#{y + 1}"
     style="fill:##{shade};"
     width="#{@box_width - 2}" height="#{@box_height - 2}"/>
    """
  end

  def triangle(point, shade) do
    {x, y} = to_pixels(point)

    """
    <polyline
      style="fill:##{shade}"
      points="#{x + 1}, #{y + 1}, #{x + @box_width}, #{y + 1}, #{x + @box_width}, #{
      y + @box_height
    }" />

    """
  end

  defp to_pixels({x, y}), do: {x * @box_width, y * @box_height}
  defp shades(:red), do: %{light: "FF0000", dark: "E00000"}
  defp shades(:blue), do: %{light: "000099", dark: "000066"}
  defp shades(:green), do: %{light: "006600", dark: "003300"}
  defp shades(:orange), do: %{light: "FF6600", dark: "FF3300"}
  defp shades(:grey), do: %{light: "686868", dark: "303030"}

  defp colors(%{name: :t}), do: :red
  defp colors(%{name: :i}), do: :blue
  defp colors(%{name: :l}), do: :green
  defp colors(%{name: :z}), do: :orange
  defp colors(%{name: :o}), do: :grey
end
