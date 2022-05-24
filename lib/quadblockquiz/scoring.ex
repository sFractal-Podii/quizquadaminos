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

  @answer_multiplier_none 1
  @answer_multiplier_1_to_9 2
  @answer_multiplier_10_to_19 3
  @answer_multiplier_20_to_49 5
  @answer_multiplier_50_to_99 7
  @answer_multiplier_over_100 11

  def tick(speed) do
    Enum.at(@drop_speeds, speed).bonus
  end

  def rows(0 = _row_count, _correct_answers) do
    # row count = 0, so no points
    0
  end

  def rows(row_count, correct_answers) do
    # base score is exponential function of number of rows
    base = 100 * round(:math.pow(2, row_count))
    # increase score by a multiple depending on questions answered
    row_question_bonus(base, correct_answers)
  end

  # multiplier = 1 if no blocks reached bottom
  def question_block_multiplier(blocks) when blocks < 2 do
    1
  end

  # multiplier = 2
  def question_block_multiplier(blocks) when blocks in 2..9 do
    2
  end

  # multiplier = 3
  def question_block_multiplier(blocks) when blocks in 10..49 do
    3
  end

  # multiplier = 5
  def question_block_multiplier(blocks) when blocks in 50..99 do
    5
  end

  # multiplier = 7
  def question_block_multiplier(blocks) when blocks in 100..299 do
    7
  end

  # multiplier = 11
  def question_block_multiplier(blocks) when blocks > 300 do
    11
  end

  defp row_question_bonus(base, 0) do
    # no answers, no bonus
    base * @answer_multiplier_none
  end

  # answered a few so double
  defp row_question_bonus(base, correct_answers)
       when correct_answers in 1..9 do
    base * @answer_multiplier_1_to_9
  end

  # triple for 10-19 answers
  defp row_question_bonus(base, correct_answers)
       when correct_answers in 10..19 do
    base * @answer_multiplier_10_to_19
  end

  # 5x for 20-49 answers
  defp row_question_bonus(base, correct_answers)
       when correct_answers in 20..49 do
    base * @answer_multiplier_20_to_49
  end

  # 7x for 50-99 answers
  defp row_question_bonus(base, correct_answers)
       when correct_answers in 50..99 do
    base * @answer_multiplier_50_to_99
  end

  # 11x for over 100 answers
  defp row_question_bonus(base, correct_answers)
       when correct_answers >= 100 do
    base * @answer_multiplier_over_100
  end
end
