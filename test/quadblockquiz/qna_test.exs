defmodule Quadblockquiz.QnaTest do
  use ExUnit.Case

  alias Quadblockquiz.QnA

  test "answers are determined by hyphen or asterisk in newline" do
    answers = QnA.question(["qna"], "open_chain_sample")

    assert Enum.count(answers.choices) == 2
  end

  test "question/1 returns the correct answers" do
    _answers = [
      {" short for fuddy-duddy", 0},
      {" random guessed*answer", 1},
      {" Fear, Uncertainty, Doubt", 2},
      {" Fair Under Duress", 3},
      {" an impolite term not suitable to repeat here", 4}
    ]

    actual_answer = "0"

    %{correct: expected_answer} = QnA.question(["qna"], "risk")

    assert actual_answer == expected_answer
  end
end
