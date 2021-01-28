defmodule Quadquizaminos.TetrominoTest do
  use ExUnit.Case

  alias Quadquizaminos.Point
  alias Quadquizaminos.Tetromino

  test "Creates a new brick" do
    assert new_brick().name == :i
  end

  test "creates a new random brick" do
    actual = Tetromino.new_random()

    assert actual.name in ~w(i l z o t)a
    assert actual.rotation in [0, 90, 180, 270]
    assert actual.reflection in [true, false]
  end

  test "manipulates brick correctly" do
    actual =
      new_brick()
      |> Tetromino.down()
      |> Tetromino.down()
      |> Tetromino.left()
      |> Tetromino.right()
      |> Tetromino.spin_90()
      |> Tetromino.spin_90()

    assert actual.location == {40, 2}
    assert actual.rotation == 180
  end

  test "should translate points" do
    assert new_brick() |> Tetromino.points() |> Point.translate({1, 1}) == [
             {3, 2},
             {3, 3},
             {3, 4},
             {3, 5}
           ]
  end

  test "should flip, rotate and mirror" do
    [{1, 1}]
    |> Point.mirror()
    |> assert_point({4, 1})
    |> Point.flip()
    |> assert_point({4, 4})
    |> Point.rotate_90()
    |> assert_point({1, 4})
    |> Point.rotate_90()
    |> assert_point({1, 1})
  end

  defp assert_point([actual], expected) do
    assert actual == expected
    [actual]
  end

  defp new_brick do
    Tetromino.new()
  end
end
