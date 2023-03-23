defmodule Quadblockquiz.BottomTest do
  use ExUnit.Case
  import Quadblockquiz.Bottom

  test "various collisions" do
    bottom = %{{1, 1} => {1, 1, :blue}}

    assert collides?(bottom, {1, 1})
    refute collides?(bottom, {1, 2})
    assert collides?(bottom, {1, 1, :blue})
    assert collides?(bottom, {1, 1, :red})
    refute collides?(bottom, {1, 2, :red})
    assert collides?(bottom, [{1, 2, :red}, {1, 1, :red}])
    refute collides?(bottom, [{1, 2, :red}, {1, 3, :red}])
  end

  test "various collisions with top and lower margin" do
    bottom = %{}

    assert collides?(bottom, {0, 1})
    refute collides?(bottom, {1, 2})
    assert collides?(bottom, {11, 1, :blue})
    assert collides?(bottom, {1, 21, :red})
    refute collides?(bottom, {1, 20, :red})
    assert collides?(bottom, [{11, 2, :red}, {10, 1, :red}])
    refute collides?(bottom, [{1, 2, :red}, {1, 3, :red}])
  end

  test "simple merge test" do
    bottom = %{{1, 1} => {1, 1, :blue}}

    actual = merge(bottom, [{1, 2, :red}, {1, 3, :red}])
    expected = %{{1, 1} => {1, 1, :blue}, {1, 2} => {1, 2, :red}, {1, 3} => {1, 3, :red}}

    assert actual == expected
  end

  test "compute complete ys" do
    bottom = new_bottom(20, [{{19, 19}, {19, 19, :red}}])

    assert complete_ys(bottom) == [20]
  end

  test "collapse single row" do
    bottom = new_bottom(20, [{{19, 19}, {19, 19, :red}}])
    actual = Map.keys(collapse_row(bottom, 20))
    refute {19, 19} in actual
    assert {19, 20} in actual
    assert Enum.count(actual) == 1
  end

  test "full collapse with single row" do
    bottom = new_bottom(20, [{{19, 19}, {19, 19, :red}}])
    {actual_count, actual_bottom} = full_collapse(bottom)

    assert actual_count == 1
    assert {19, 20} in Map.keys(actual_bottom)
  end

  test "does not collapse row with vulnerabilty" do
    bottom =
      bottom_with_vulnerability(20, [
        {{10, 20}, {10, 20, :vuln_grey_yellow}},
        {{19, 19}, {19, 19, :red}}
      ])

    {count, unchanged_bottom} = full_collapse(bottom)
    assert count == 0
    assert {10, 20} in Map.keys(unchanged_bottom)
  end

  test "collapse other rows even when vulnerability is present in other rows" do
    bottom = new_bottom(20, [{{1, 19}, {1, 19, :vuln_grey_yellow}}])
    {_count, updated_bottom} = full_collapse(bottom)
    {:ok, value} = Map.fetch(updated_bottom, {1, 20})
    assert value == {1, 20, :vuln_grey_yellow}
  end

  def bottom_with_vulnerability(complete_row, xtras) do
    (xtras ++
       (1..9
        |> Enum.map(fn x ->
          {{x, complete_row}, {x, complete_row, :red}}
        end)))
    |> Map.new()
  end

  def new_bottom(complete_row, xtras) do
    (xtras ++
       (1..10
        |> Enum.map(fn x ->
          {{x, complete_row}, {x, complete_row, :red}}
        end)))
    |> Map.new()
  end

  test "add vulnerabilities - empty bottom" do
    bottom = %{}
    new_bottom = add_vulnerability(bottom)

    actual = Enum.any?(new_bottom, fn {{x, y}, value} -> {x, y, :vuln_grey_yellow} == value end)

    assert actual
  end

  test "add vulnerabilities - non-empty bottom" do
    bottom = %{{4, 20} => {4, 20, :red}}
    actual = add_vulnerability(bottom)
    expected = %{{4, 20} => {4, 20, :vuln_grey_yellow}}
    assert actual == expected
  end
end
