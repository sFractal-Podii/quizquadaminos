defmodule QuadBlockQuiz.PointsTest do
  use ExUnit.Case
  alias QuadBlockQuiz.Points

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
      actual = Points.with_color(points, color, 23)
      expected = [{2, 1, :red}, {2, 2, :red}, {2, 3, :red}, {2, 4, :red}]

      assert actual == expected

      actual = Points.with_color(points, color, 21)
      expected = [{2, 1, :red}, {2, 2, :red}, {2, 3, :red}, {2, 4, :vuln_grey_yellow}]

      assert actual == expected
    end
  end
end
