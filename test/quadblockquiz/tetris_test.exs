defmodule Quadblockquiz.TetrisTest do
  use ExUnit.Case
  import Quadblockquiz.Tetris
  alias Quadblockquiz.Brick

  test "try to move right, success" do
    brick = Brick.new(location: {5, 1})
    bottom = %{}

    expected = brick |> Brick.right()
    actual = try_right(brick, bottom)

    assert actual == expected
  end

  test "try to move right, failure returns original brick" do
    brick = Brick.new(location: {8, 1})
    bottom = %{}

    actual = try_right(brick, bottom)

    assert actual == brick
  end

  test "drops without merging" do
    brick = Brick.new(location: {5, 5})
    bottom = %{}
    brick_count = 0

    expected = %{
      brick: Brick.down(brick),
      bottom: %{},
      game_over: false,
      brick_count: 0,
      row_count: 0
    }

    actual = drop(brick, bottom, :red, brick_count)

    assert actual == expected
  end

  test "drops and merges" do
    brick = Brick.new(location: {5, 16})
    bottom = %{}
    brick_count = 1

    %{bottom: bottom} = Quadblockquiz.Tetris.drop(brick, bottom, :red, brick_count)

    assert Map.get(bottom, {7, 20}) == {7, 20, :red}
  end

  test "drops to bottom and compresses" do
    brick = Brick.new(location: {5, 16})
    brick_count = 1

    bottom =
      for x <- 1..10, y <- 17..20, x != 7 do
        {{x, y}, {x, y, :red}}
      end
      |> Map.new()

    %{bottom: bottom} = Quadblockquiz.Tetris.drop(brick, bottom, :red, brick_count)

    assert bottom == %{}
  end
end
