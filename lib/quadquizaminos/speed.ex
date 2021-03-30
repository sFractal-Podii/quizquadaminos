defmodule Quadquizaminos.Speed do

  @drop_speeds [
    # 20/s, 50 ms
    %{name: "full throttle", ratio: 1},
    # 10/s, 100 ms
    %{name: "high speed", ratio: 2},
    # 4/s, 250 ms. - default game starts with
    %{name: "fast", ratio: 5},
    # ~3/s, 350 ms
    %{name: "moderate", ratio: 7},
    # 2/s, 500 ms
    %{name: "leisurely", ratio: 10},
    # 3/2s, 750 ms
    %{name: "sedate", ratio: 15},
    # 1/s, 1000 ms
    %{name: "lethargic", ratio: 20}
  ]

  def speed_name(speed) do
    Enum.at(@drop_speeds, speed).name
  end

  def speed_tick_count(speed) do
    Enum.at(@drop_speeds, speed).tick_count
  end

  def highest_speed() do
    0
  end

  def lowest_speed() do
    length(@drop_speeds) - 1
  end


  def increase_speed(speed) do
    if speed - 1 < highest_speed(), do: highest_speed(), else: speed - 1
  end

  def decrease_speed(speed) do
    if speed + 1 > lowest_speed(), do: lowest_speed(), else: speed + 1
  end

end
