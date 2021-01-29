defmodule Quadquizaminos.Point do
  def move_to_location(points, {x, y} = _location) do
    Enum.map(points, fn {dx, dy} -> {dx + x, dy + y} end)
  end

  def transpose(points) do
    Enum.map(points, fn {x, y} -> {y, x} end)
  end

  def mirror(points) do
    Enum.map(points, fn {x, y} -> {5 - x, y} end)
  end

  def mirror(points, false), do: points

  def mirror(points, true), do: mirror(points)

  def flip(points) do
    Enum.map(points, fn {x, y} -> {x, 5 - y} end)
  end

  def rotate_90(points) do
    points
    |> transpose()
    |> mirror()
  end

  def rotate(points, 0), do: points

  def rotate(points, degrees) do
    rotate(rotate_90(points), degrees - 90)
  end

  def with_color(points, color) do
    Enum.map(points, fn point -> add_color(point, color) end)
  end

  defp add_color({_x, _y, _c} = points, _color), do: points
  defp add_color({x, y}, color), do: {x, y, color}
end
