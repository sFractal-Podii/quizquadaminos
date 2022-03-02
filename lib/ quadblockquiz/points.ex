defmodule Quadblockquiz.Points do
  def move_to_location(points, {x, y} = _location) do
    Enum.map(points, fn {dx, dy} -> {dx + x, dy + y} end)
  end

  def transpose(points) do
    points
    |> Enum.map(fn {x, y} -> {y, x} end)
  end

  def mirror(points) do
    points
    |> Enum.map(fn {x, y} -> {5 - x, y} end)
  end

  def mirror(points, false), do: points
  def mirror(points, true), do: mirror(points)

  def flip(points) do
    points
    |> Enum.map(fn {x, y} -> {x, 5 - y} end)
  end

  def rotate_90(points) do
    points
    |> transpose
    |> mirror
  end

  def rotate(points, 0), do: points

  def rotate(points, degrees) do
    rotate(
      rotate_90(points),
      degrees - 90
    )
  end

  def with_color(points, color, brick_count) do
    threshold = Application.get_env(:quadblockquiz, :vulnerability_new_brick_threshold)

    case rem(brick_count, threshold) do
      0 ->
        position = div(brick_count, threshold)

        position =
          if position > 3 do
            0
          else
            position
          end

        points =
          List.update_at(points, position, fn {x, y} ->
            {x, y, :vuln_grey_yellow}
          end)

        Enum.map(points, fn point ->
          add_color(point, color)
        end)

      _ ->
        Enum.map(points, fn point -> add_color(point, color) end)
    end
  end

  defp add_color({_x, _y, _c} = point, _color), do: point
  defp add_color({x, y}, color), do: {x, y, color}

  def to_string(points) do
    map =
      points
      |> Map.new()

    for y <- 1..4, x <- 1..4 do
      Map.get(map, {x, y}, "□")
    end
    |> Enum.chunk_every(4)
    |> Enum.map_join(fn key -> {key, "■"} end)
    |> Enum.join("\n")
  end
end
