defmodule Quadquizaminos.QnaTest do
  use ExUnit.Case

  alias Quadquizaminos.QnA

  test "answers are determined by hyphen or asterisk in newline" do
    # category with two answers
    [category | _] = QnA.categories()

    %{answers: answers} = QnA.question(category)

    assert Enum.count(answers) == 2
  end
end
