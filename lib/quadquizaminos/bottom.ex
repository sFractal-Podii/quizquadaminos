defmodule Quadquizaminos.Bottom do
  alias Quadquizaminos.Presets

  def merge(bottom, points) do
    points
    |> Enum.map(fn {x, y, c} -> {{x, y}, {x, y, c}} end)
    |> Enum.into(bottom)
  end

  def collides?(bottom, {x, y, _color}), do: collides?(bottom, {x, y})

  def collides?(bottom, {x, y}) do
    !!Map.get(bottom, {x, y}) || x < 1 || x > 10 || y > 20
  end

  def collides?(bottom, points) when is_list(points) do
    Enum.any?(points, &collides?(bottom, &1))
  end

  def complete_ys(bottom) do
    bottom
    |> Map.keys()
    |> Enum.map(&elem(&1, 1))
    |> Enum.uniq()
    |> Enum.filter(fn row -> complete?(bottom, row) end)
  end

  def complete?(bottom, row) do
    count =
      bottom
      |> Map.keys()
      |> Enum.filter(fn {_x, y} -> y == row end)
      |> Enum.count()

    count == 10
  end

  def collapse_row(bottom, row) do
    bad_keys =
      bottom
      |> Map.keys()
      |> Enum.filter(fn {_x, y} -> y == row end)

    bottom
    |> Map.drop(bad_keys)
    |> Enum.map(&move_bad_point_up(&1, row))
    |> Map.new()
  end

  def move_bad_point_up({{x, y}, {x, y, color}}, row) when y < row do
    {{x, y + 1}, {x, y + 1, color}}
  end

  def move_bad_point_up(key_value, _row) do
    key_value
  end

  def full_collapse(bottom) do
    rows =
      bottom
      |> complete_ys
      |> Enum.sort()

    new_bottom = Enum.reduce(rows, bottom, &collapse_row(&2, &1))

    {Enum.count(rows), new_bottom}
  end

  def add_attack(bottom) do
    bottom
    |> Map.merge(
       Presets.attack(),
       fn _k, _prev_valuse, attack_value ->
         attack_value
       end)
  end

  def add_lawsuit(bottom) do
    bottom
    |> Map.merge(
       Presets.lawsuit(),
       fn _k, _prev_value, ls_value ->
         ls_value
       end)
  end

  def add_vulnerability(bottom) when bottom == %{} do
    ## empty input map, so stick one in anyway
    %{{1, 20} => {1, 20, :vuln_grey_yellow}}
  end

  def add_vulnerability(bottom) do
    ## pick random bottom block and change to add_vulnerability
    {{x, y}, _} = Enum.random(bottom)
    bottom
    |> Map.merge(
      %{{x, y} => {x, y, :vuln_grey_yellow}},
        fn _k, _prev_value, vuln_value ->
          vuln_value
        end)
  end

  def add_license_issue(bottom) when bottom == %{} do
    ## if no blocks to have issue, add one anyway
    %{{1, 20} => {1, 20, :license_grey_brown}}
  end

  def add_license_issue(bottom) do
    ## pick random bottom block and change to add_vulnerability
    {{x, y}, _} = Enum.random(bottom)
    bottom
    |> Map.merge(
       %{{x, y} => {x, y, :license_grey_brown}},
       fn _k, _prev_value, ls_value ->
         ls_value
       end)
  end

  def remove_all_vulnerabilities(bottom) do
    bottom
    |> Enum.filter(
      fn _key,value ->
        {_x,_y,color} = value
        color != :vuln_grey_yellow
      end)
  end

  def remove_all_license_issues(bottom) do
    bottom
    |> Enum.filter(
      fn _key,value ->
        {_x,_y,color} = value
        color != :license_grey_brown
      end)
  end

end
