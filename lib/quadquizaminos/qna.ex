defmodule Quadquizaminos.QnA do
  def question do
    build()
  end

  defp build do
    {:ok, content} = File.read("qna/sbom/001.md")
    [question, answers] = content |> String.split(~r/# answers/i)
    %{question: question(question), answers: answers(answers), correct: correct_answer(answers)}
  end

  defp answers(answers) do
    answers
    |> String.replace("\n", "")
    |> String.split(["-", "*"], trim: true)
    |> Enum.with_index()
  end

  defp question(question) do
    {:ok, question, _} = Earmark.as_html(question)
    question |> String.replace("#", "")
  end

  defp correct_answer(answers) do
    regex = ~r/(-|\*)/

    {_, correct} =
      Regex.scan(regex, answers, capture: :first)
      |> List.flatten()
      |> Enum.with_index()
      |> Enum.find(fn {k, _v} -> k == "*" end)

    correct |> to_string()
  end
end
