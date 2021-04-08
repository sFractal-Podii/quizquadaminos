defmodule Quadquizaminos.PointsTest do
  use ExUnit.Case
  alias Quadquizaminos.Points

  describe "points with color" do
    setup do
      points = [
        {2, 1},
        {2, 2},
        {2, 3},
        {2, 4}
      ]

      color = :red

      [points: points, color: color]
    end

    test "vulnerability is added to incoming block when brick count can be evenly divided", %{
      points: points,
      color: color
    } do
      socket = %{
        assigns: %{brick_count: 23, gametime_counter: 1, fewer_vuln_powerup: 0}
      }

      actual = Points.with_color(points, color, socket)
      expected = [{2, 1, :red}, {2, 2, :red}, {2, 3, :red}, {2, 4, :red}]

      assert actual == expected

      socket = %{
        assigns: %{brick_count: 21, gametime_counter: 1, fewer_vuln_powerup: 0}
      }

      actual = Points.with_color(points, color, socket)
      expected = [{2, 1, :red}, {2, 2, :red}, {2, 3, :red}, {2, 4, :vuln_grey_yellow}]

      assert actual == expected
    end
  end
end
