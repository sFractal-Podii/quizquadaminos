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
      |> remove_trouble_blocks()
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

  def add_vulnerability(bottom) when %{} == bottom do
    ## empty input map, so stick one in anyway
    %{{1, 20} => {1, 20, :vuln_grey_yellow}}
  end

  def add_vulnerability(bottom) do
    ## pick random bottom block and change to add_vulnerability
    ## only pick blocks that are not already marked with some 'trouble'
    {{x, y}, _} = bottom
    |> remove_trouble_blocks()
    |> Enum.random()

    bottom
    |> Map.merge(
      %{{x, y} => {x, y, :vuln_grey_yellow}},
        fn _k, _prev_value, vuln_value ->
          vuln_value
        end)
  end

  def add_license_issue(bottom) when %{} == bottom do
    ## if no blocks to have issue, add one anyway
    %{{1, 20} => {10, 20, :license_grey_brown}}
  end

  def add_license_issue(bottom) do
    ## pick random bottom block and change to license issue
    ## only pick blocks that are not already marked with some 'trouble'
    {{x, y}, _} = bottom
    |> remove_trouble_blocks
    |> Enum.random

    bottom
    |> Map.merge(
      # block to be added
      %{{x, y} => {x, y, :license_grey_brown}},
      # if occupied, use licence issue color
      fn _k, _prev_value, ls_value ->
         ls_value
       end)
  end

  def remove_all_vulnerabilities(bottom) do
    remove_a_color(bottom, :vuln_grey_yellow)
  end

  def remove_all_license_issues(bottom) do
    remove_a_color(bottom, :license_grey_brown)
  end

  def remove_attacks(bottom) do
    remove_a_color(bottom, :attack_yellow_gold)
  end

  def remove_lawsuits(bottom) do
    remove_a_color(bottom, :lawsuit_brown_gold)
  end

  def remove_a_color(bottom, color_to_be_removed) do
    bottom
    |> Enum.filter(
      fn block ->
        {{_x,_y},{_x,_y,color}} = block
        color != color_to_be_removed
      end)
  end

  def attacked?(bottom, attack_threshold) do
    ## see if under attack
    vuln_count =
        bottom
        |> Enum.filter(
          fn block ->
            {_key, {_x,_y,color}} = block
            color == :vuln_grey_yellow
          end)
        |> Enum.count
    ## return true if more vuln's than attack_threshold
    vuln_count >= attack_threshold
  end

  def sued?(bottom, suit_threshold) do
    ## see if being sued (count license issues)
    li_count =
        bottom
        |> Enum.filter(
          fn block ->
            {_key, {_x,_y,color}} = block
            color == :license_grey_brown
          end)
        |> Enum.count
    ## return true if more vuln's than attack_threshold
    li_count >= suit_threshold
  end

  def remove_trouble_blocks(bottom) do
    bottom
    |> remove_all_vulnerabilities
    |> remove_all_license_issues
    |> remove_attacks
    |> remove_lawsuits
  end

end
