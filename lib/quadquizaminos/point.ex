defmodule Quadquizaminos.Point do
  def translate(points, {x, y}) do
    Enum.map(points, fn {dx, dy} -> {dx + x, dy + y} end)
  end

  def transpose(points) do
    Enum.map(points, fn {x, y} -> {y, x} end)
  end

  def mirror(points) do
    Enum.map(points, fn {x, y} -> {5 - x, y} end)
  end

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
end
