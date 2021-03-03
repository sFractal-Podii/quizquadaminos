defmodule Quadquizaminos.QnA do
  @qna_directory Application.get_env(:quadquizaminos, :qna_directory)

  def question do
    build()
  end

  def question(nil) do
    %{}
  end

  def question(category) do
    build(category)
  end

  def categories do
    "qna"
    |> File.ls!()
    |> Enum.filter(fn folder ->
      File.dir?("./qna/#{folder}") and not (File.ls!("./qna/#{folder}") |> Enum.empty?())
    end)
  end

  defp build do
    categories |> Enum.random() |> build()
  end

  defp build(category) do
    {:ok, content} = category |> choose_file() |> File.read()
    [question, answers] = content |> String.split(~r/## answers/i)

    %{
      question: question_as_html(question),
      answers: answers(answers),
      correct: correct_answer(answers)
    }
  end

  defp answers(answers) do
    answers
    |> String.replace("\n", "")
    |> String.split(["-", "*"], trim: true)
    |> Enum.with_index()
  end

  defp question_as_html(question) do
    {:ok, question, _} = Earmark.as_html(question)
    question |> String.replace("#", "")
  end

  defp choose_file(category) do
    path = "#{@qna_directory}/#{category}"
    {:ok, files} = File.ls(path)
    Path.join(path, Enum.random(files))
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
