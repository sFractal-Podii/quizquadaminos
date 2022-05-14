defmodule Quadblockquiz.Scoring do
  # each speed has a scoring bonus
  @drop_speeds [
    %{name: "full throttle", bonus: 10},
    %{name: "high speed", bonus: 5},
    %{name: "fast", bonus: 2},
    %{name: "moderate", bonus: 1},
    %{name: "leisurely", bonus: 0},
    %{name: "sedate", bonus: 0},
    %{name: "lethargic", bonus: 0}
  ]

  def tick(speed) do
    Enum.at(@drop_speeds, speed).bonus
  end

  def rows(0 = _row_count, _correct_answers) do
    # row count = 0, so no points
    0
  end

  def rows(row_count, correct_answers) do
    # base score is exponential function of number of rows
    base =  100 * round(:math.pow(2, row_count))
    # increase score by a multiple depending on questions answered
    row_question_bonus(base, correct_answers)
  end

  defp row_question_bonus(base, 0) do
    # no answers, no bonus
    base
  end

  defp row_question_bonus(base, correct_answers)
    when correct_answers in 1..9 do
      # answered a few so double
      base * 2
  end

  defp row_question_bonus(base, correct_answers)
    when correct_answers in 10..19 do
      # triple for 10-19 answers
      base * 3
  end

  defp row_question_bonus(base, correct_answers)
    when correct_answers in 20..49 do
      # 5x for 20-49 answers
      base * 5
  end

  defp row_question_bonus(base, correct_answers)
    when correct_answers in 50..99 do
      # 5x for 20-49 answers
      base * 7
  end

  defp row_question_bonus(base, correct_answers)
    when correct_answers >= 100 do
      # 5x for 20-49 answers
      base * 11
  end

end
