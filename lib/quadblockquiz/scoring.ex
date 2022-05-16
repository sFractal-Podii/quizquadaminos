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

  @answer_multiplier [
    %{name: "none", multiplier: 1},
    %{name: "1 to 9", multiplier: 2},
    %{name: "10 to 19", multiplier: 3},
    %{name: "20 to 49", multiplier: 5},
    %{name: "50 to 99", multiplier: 7},
    %{name: "100 or more", multiplier: 11}
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
    base * Enum.at(@answer_multiplier, 0).multiplier
  end

  defp row_question_bonus(base, correct_answers)
    when correct_answers in 1..9 do
      # answered a few so double
      base * Enum.at(@answer_multiplier, 1).multiplier
  end

  defp row_question_bonus(base, correct_answers)
    when correct_answers in 10..19 do
      # triple for 10-19 answers
      base * Enum.at(@answer_multiplier, 2).multiplier
  end

  defp row_question_bonus(base, correct_answers)
    when correct_answers in 20..49 do
      # 5x for 20-49 answers
      base * Enum.at(@answer_multiplier, 3).multiplier
  end

  defp row_question_bonus(base, correct_answers)
    when correct_answers in 50..99 do
      # 5x for 20-49 answers
      base * Enum.at(@answer_multiplier, 4).multiplier
  end

  defp row_question_bonus(base, correct_answers)
    when correct_answers >= 100 do
      # 5x for 20-49 answers
      base * Enum.at(@answer_multiplier, 5).multiplier
  end

end
