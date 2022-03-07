defmodule QuadquizaminosWeb.SvgBoard do
  @box_width 20
  @box_height 20
  def svg_head do
    """
    <svg
    version="1.0"
    style="background-color: #F8F8F8"
    id="Layer_1"
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    width="200" height="400"
    viewBox="0 0 200 400"
    xml:space="preserve"
    aria-labelledby="title">
    """
  end

  def svg_foot, do: "</svg>"

  def boxes(points_with_colors) do
    points_with_colors
    |> Enum.map_join("\n", fn {x, y, color} -> box({x, y}, color) end)
  end

  def box({_x, _y} = point, color) do
    """
    #{square(point, shades(color).light)}
    #{triangle(point, shades(color).dark)}
    """
  end

  def square(point, shade) do
    {x, y} = to_pixels(point, 20, 20)

    """
    <rect
      x="#{x + 1}" y="#{y + 1}"
      style="fill:##{shade};"
      width="#{@box_width - 2}" height="#{@box_height - 1}"/>
    """
  end

  def triangle(point, shade) do
    {x, y} = to_pixels(point, 20, 20)
    {w, h} = {@box_width, @box_height}

    """
    <polyline
        style="fill:##{shade}"
        points="#{x + 1},#{y + 1} #{x + w},#{y + 1} #{x + w},#{y + h}" />
    """
  end

  def to_pixels({x, y}, bw, bh), do: {(x - 1) * bw, (y - 1) * bh}

  defp shades(:red), do: %{light: "f8070a", dark: "FA383B"}
  defp shades(:blue), do: %{light: "00BFFF", dark: "1E90FF"}
  defp shades(:green), do: %{light: "00ff00", dark: "00c300"}
  defp shades(:orange), do: %{light: "FFA500", dark: "FF8C00"}
  defp shades(:pink), do: %{light: "FF69B4", dark: "FF1493"}
  defp shades(:purple), do: %{light: "ff00ff", dark: "800080"}
  defp shades(:vuln_grey_yellow), do: %{light: "A1A09E", dark: "ffff00"}
  defp shades(:license_grey_brown), do: %{light: "A1A09E", dark: "8B4513"}
  defp shades(:attack_yellow_gold), do: %{light: "ffff00", dark: "DAA520"}
  defp shades(:lawsuit_brown_gold), do: %{light: "8B4513", dark: "DAA520"}

  def color(%{name: :t}), do: :red
  def color(%{name: :i}), do: :blue
  def color(%{name: :l}), do: :green
  def color(%{name: :o}), do: :orange
  def color(%{name: :z}), do: :pink
end
