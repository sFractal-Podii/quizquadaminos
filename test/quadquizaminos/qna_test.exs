defmodule Quadquizaminos.QnaTest do
  use ExUnit.Case

  alias Quadquizaminos.QnA

  test "answers are determined by hyphen or asterisk in newline" do
    # category with two answers

    %{answers: answers} = QnA.question("open_chain_sample")

    assert Enum.count(answers) == 2
  end

  test "question/1 returns the correct answers" do
    _answers = [
      {" short for fuddy-duddy", 0},
      {" random guessed*answer", 1},
      {" Fear, Uncertainty, Doubt", 2},
      {" Fair Under Duress", 3},
      {" an impolite term not suitable to repeat here", 4}
    ]

    actual_answer = "2"
    %{correct: expected_answer} = QnA.question("risk")
    assert actual_answer == expected_answer
  end
end
