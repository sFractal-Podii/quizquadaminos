defmodule Quadquizaminos.QnA do
  @qna_directory Application.app_dir(:quadquizaminos, "priv/static/qna")

  def question do
    build()
  end

  defp build do
    {:ok, content} = choose_file() |> File.read()
    [question, answers] = content |> String.split(~r/## answers/i)
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

  defp choose_file do
    IO.inspect(@qna_directory)
    {:ok, files} = File.ls("#{@qna_directory}/sbom")
    IO.inspect(files)
    Path.join("#{@qna_directory}/sbom", Enum.random(files))
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
