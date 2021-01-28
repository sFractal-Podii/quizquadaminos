defmodule Quadquizaminos.Tetromino do
  defstruct name: :i, location: {40, 0}, rotation: 0, reflection: false

  def new(attributes \\ []), do: __struct__(attributes)

  def new_random do
    %__MODULE__{
      name: random_name(),
      location: {40, 0},
      rotation: random_rotation(),
      reflection: random_reflection()
    }
  end

  def random_name do
    ~w(i l z o t)a
    |> Enum.random()
  end

  def random_rotation do
    [0, 90, 180, 270]
    |> Enum.random()
  end

  def random_reflection do
    [true, false]
    |> Enum.random()
  end

  def down(brick) do
    %{brick | location: point_down(brick.location)}
  end

  def left(brick) do
    %{brick | location: point_left(brick.location)}
  end

  def right(brick) do
    %{brick | location: point_right(brick.location)}
  end

  def point_down({x, y}) do
    {x, y + 1}
  end

  def point_left({x, y}) do
    {x - 1, y}
  end

  def point_right({x, y}) do
    {x + 1, y}
  end

  def spin_90(brick) do
    %{brick | rotation: rotate(brick.rotation)}
  end

  def rotate(270), do: 0
  def rotate(degrees), do: degrees + 90

  def points(%{name: :i}) do
    [
      {2, 1},
      {2, 2},
      {2, 3},
      {2, 4}
    ]
  end

  def points(%{name: :l}) do
    [
      {2, 1},
      {2, 2},
      {2, 3},
      {3, 3}
    ]
  end

  def points(%{name: :z}) do
    [
      {2, 2},
      {2, 3},
      {3, 3},
      {3, 4}
    ]
  end

  def points(%{name: :o}) do
    [
      {2, 2},
      {3, 2},
      {2, 3},
      {3, 3}
    ]
  end

  def points(%{name: :t}) do
    [
      {2, 1},
      {2, 2},
      {2, 3},
      {3, 3}
    ]
  end

  def to_string(brick) do
    map = brick |> points() |> Enum.map(fn key -> {key, "X"} end) |> Map.new()

    for y <- 1..4, x <- 1..4 do
      Map.get(map, {x, y}, "O")
    end
    |> Enum.chunk_every(4)
  end
end
