defmodule Quadblockquiz.ScoringTest do
  use ExUnit.Case
  alias Quadblockquiz.Scoring

  test "full throttle tick" do
    expected = 10
    actual = Scoring.tick(0)

    assert actual == expected
  end

  test "moderate tick" do
    expected = 1
    actual = Scoring.tick(3)

    assert actual == expected
  end

  test "no row, 5 questions" do
    expected = 0
    actual = Scoring.rows(0, 5)

    assert actual == expected
  end

  test "1 row, no questions" do
    expected = 200
    actual = Scoring.rows(1, 0)

    assert actual == expected
  end

  test "1 row, 2 questions" do
    expected = 400
    actual = Scoring.rows(1, 1)

    assert actual == expected
  end

  test "1 row, 14 questions" do
    expected = 600
    actual = Scoring.rows(1, 14)

    assert actual == expected
  end

  test "1 row, 23 questions" do
    expected = 1000
    actual = Scoring.rows(1, 23)

    assert actual == expected
  end

  test "1 row, 55 questions" do
    expected = 1400
    actual = Scoring.rows(1, 55)

    assert actual == expected
  end

  test "1 row, 114 questions" do
    expected = 2200
    actual = Scoring.rows(1, 114)

    assert actual == expected
  end

  test "2 row, no questions" do
    expected = 400
    actual = Scoring.rows(2, 0)

    assert actual == expected
  end

  test "3 row, 2 questions" do
    expected = 1600
    actual = Scoring.rows(3, 2)

    assert actual == expected
  end

  test "4 row, 14 questions" do
    expected = 4800
    actual = Scoring.rows(4, 14)

    assert actual == expected
  end

  test "5 row, 23 questions" do
    expected = 16_000
    actual = Scoring.rows(5, 23)

    assert actual == expected
  end

  test "5 row, 1 questions" do
    expected = 6400
    actual = Scoring.rows(5, 1)

    assert actual == expected
  end

  test "4 row, 114 questions" do
    expected = 17_600
    actual = Scoring.rows(4, 114)

    assert actual == expected
  end
end
