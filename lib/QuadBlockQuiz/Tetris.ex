defmodule QuadBlockQuiz.Tetris do
  alias QuadBlockQuiz.{Bottom, Brick, Points}

  def prepare(brick) do
    brick
    |> Brick.prepare()
    |> Points.move_to_location(brick.location)
  end

  def drop(brick, bottom, color, brick_count) do
    new_brick = Brick.down(brick)

    maybe_do_drop(
      Bottom.collides?(bottom, prepare(new_brick)),
      bottom,
      brick,
      new_brick,
      color,
      brick_count
    )
  end

  def maybe_do_drop(true = _collided, bottom, old_brick, _new_block, color, brick_count) do
    new_brick = Brick.new_random()

    points =
      old_brick
      |> prepare
      |> Points.with_color(color, brick_count)

    {count, new_bottom} =
      bottom
      |> Bottom.merge(points)
      |> Bottom.full_collapse()

    %{
      brick: new_brick,
      bottom: new_bottom,
      score: score(count),
      row_count: count,
      # hit bottom so increment brick_count
      brick_count: 1,
      game_over: Bottom.collides?(new_bottom, prepare(new_brick))
    }
  end

  def maybe_do_drop(false = _collided, bottom, _old_block, new_block, _color, _brick_count) do
    %{
      brick: new_block,
      bottom: bottom,
      score: 1,
      # no rows completed since didn't reach bottom yet
      row_count: 0,
      # didn't hit bottom so do not increment brick_count
      brick_count: 0,
      game_over: false
    }
  end

  def score(0), do: 0

  def score(count) do
    100 * round(:math.pow(2, count))
  end

  def try_left(brick, bottom), do: try_move(brick, bottom, &Brick.left/1)
  def try_right(brick, bottom), do: try_move(brick, bottom, &Brick.right/1)
  def try_spin_90(brick, bottom), do: try_move(brick, bottom, &Brick.spin_90/1)

  defp try_move(brick, bottom, f) do
    new_brick = f.(brick)

    if Bottom.collides?(bottom, prepare(new_brick)) do
      brick
    else
      new_brick
    end
  end
end
