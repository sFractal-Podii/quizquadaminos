defmodule Quadblockquiz.Bottom do
  alias Quadblockquiz.Presets

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

  def has_vulnerable_block?(bottom, row) do
    bottom
    |> Enum.map(fn {_key, value} -> value end)
    |> Enum.any?(fn {_x, y, color} -> y == row and color == :vuln_grey_yellow end)
  end

  def complete_ys(bottom) do
    bottom
    |> Map.keys()
    |> Enum.map(&elem(&1, 1))
    |> Enum.uniq()
    |> Enum.filter(fn row -> complete?(bottom, row) and !has_vulnerable_block?(bottom, row) end)
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
      end
    )
  end

  def add_lawsuit(bottom) do
    bottom
    |> Map.merge(
      Presets.lawsuit(),
      fn _k, _prev_value, ls_value ->
        ls_value
      end
    )
  end

  def add_vulnerability(bottom) do
    ## don't put on top of existing issue
    clean = remove_trouble_blocks(bottom)
    if clean != %{} do
      # some clean blocks in bottom, pick random one and add issue
      {{x, y}, _} = Enum.random(clean)
      add_trouble_block(x, y, :vuln_grey_yellow, bottom)
    else
      # bottom is empty or only has vulns/issues
      {x, y} = find_empty_block(bottom)
      add_trouble_block(x, y, :vuln_grey_yellow, bottom)
    end
  end

  def add_license_issue(bottom) do
    ## don't put on top of existing issue
    clean = remove_trouble_blocks(bottom)
    if clean != %{} do
      # some clean blocks in bottom, pick random one and add issue
      {{x, y}, _} = Enum.random(clean)
      add_trouble_block(x, y, :license_grey_brown, bottom)
    else
      # bottom is empty or only has vulns/issues
      {x, y} = find_empty_block(bottom)
      add_trouble_block(x, y, :license_grey_brown, bottom)
    end
  end

  def remove_all_vulnerabilities(bottom) when %{} == bottom do
    ## if no blocks just return empty
    bottom
  end

  def remove_all_vulnerabilities(bottom) do
    remove_a_color(bottom, :vuln_grey_yellow)
  end

  def remove_all_license_issues(bottom) when %{} == bottom do
    ## if no blocks just return empty
    bottom
  end

  def remove_all_license_issues(bottom) do
    remove_a_color(bottom, :license_grey_brown)
  end

  def remove_attacks(bottom) when %{} == bottom do
    ## if no blocks just return empty
    bottom
  end

  def remove_attacks(bottom) do
    remove_a_color(bottom, :attack_yellow_gold)
  end

  def remove_lawsuits(bottom) when %{} == bottom do
    ## if no blocks just return empty
    bottom
  end

  def remove_lawsuits(bottom) do
    remove_a_color(bottom, :lawsuit_brown_gold)
  end

  def remove_a_color(bottom, color_to_be_removed) do
    bottom
    |> Enum.filter(fn block ->
      {_key, {_x, _y, color}} = block
      color != color_to_be_removed
    end)
    |> Map.new()
  end

  def remove_vuln_and_license(bottom, {x, y, _color} = value) do
    if Map.has_key?(bottom, {x, y}) do
      value =
        case value do
          {x, y, :vuln_grey_yellow} -> {x, y, :purple}
          {x, y, :license_grey_brown} -> {x, y, :purple}
          _ -> value
        end

      Map.merge(bottom, %{{x, y} => value})
    else
      bottom
    end
  end

  def attacked?(bottom, attack_threshold) do
    ## see if under attack
    vuln_count =
      bottom
      |> Enum.filter(fn block ->
        {_key, {_x, _y, color}} = block
        color == :vuln_grey_yellow
      end)
      |> Enum.count()

    ## return true if more vuln's than attack_threshold
    vuln_count >= attack_threshold
  end

  def sued?(bottom, suit_threshold) do
    ## see if being sued (count license issues)
    li_count =
      bottom
      |> Enum.filter(fn block ->
        {_key, {_x, _y, color}} = block
        color == :license_grey_brown
      end)
      |> Enum.count()

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

  defp find_empty_block(bottom) do
    # make list of empty blocks in bottom row
    used = Map.keys(bottom)
    possible = for i <- 1..11, do: {i, 20}
    unused = possible -- used
    # pick a random empty block
    {x, y} = Enum.random(unused)
  end

  defp add_trouble_block(x, y, color, bottom) do
    bottom
    |> Map.merge(
      # block to be added
      %{{x, y} => {x, y, color}},
      # if occupied, use licence issue color
      fn _k, _prev_value, ls_value ->
        ls_value
      end
    )
  end
end
