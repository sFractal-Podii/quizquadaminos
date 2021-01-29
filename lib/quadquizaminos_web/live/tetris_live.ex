defmodule QuadquizaminosWeb.TetrisLive do
  use QuadquizaminosWeb, :live_view

  import Phoenix.HTML, only: [raw: 1]
  alias Quadquizaminos.Tetromino

  @box_width 20
  @box_height 20

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(tetromino: Tetromino.new_random() |> Tetromino.to_string())}
  end

  def render(assigns) do
    ~L"""
       <pre><%= @tetromino %></pre>
       <div>
       <%= raw svg_head() %>
       	<%= raw box({1, 2}, :red) %>
       	<%= raw svg_foot() %>
       </div>

    """
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
end
