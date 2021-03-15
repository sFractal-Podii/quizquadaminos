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

  def question(category, position) do
    build(category, position)
  end

  def categories do
    @qna_directory
    |> File.ls!()
    |> Enum.filter(fn folder ->
      File.dir?("#{@qna_directory}/#{folder}") and
        not (File.ls!("#{@qna_directory}/#{folder}") |> Enum.empty?())
    end)
  end

  defp build do
    categories |> Enum.random() |> build()
  end

  defp build(category, position \\ 0) do
    {:ok, content} = category |> choose_file(position) |> File.read()

    [question, answers_scores] = content |> String.split(~r/## answers/i)

    [answers, score] =
      answers_scores
      |> String.split(~r/## score/i)
      |> answer_and_score()

    %{
      question: question_as_html(question),
      answers: answers(content, answers),
      correct: correct_answer(answers),
      powerup: powerup(content),
      score: score(score)
    }
  end

  defp answer_and_score([answers | []]), do: [answers, nil]
  defp answer_and_score([answers, scores]), do: [answers, scores]

  defp score(nil), do: %{"Right" => "25", "Wrong" => "5"}

  defp score(score) do
    score
    |> String.replace("\n", "")
    |> String.split("-", trim: true)
    |> Enum.map(fn score ->
      score |> String.trim_leading() |> String.split(":") |> List.to_tuple()
    end)
    |> Map.new()
  end

  defp powerup(content) do
    regex = ~r/# powerup(?<powerup>.*)/i

    case Regex.named_captures(regex, content |> String.replace("\n", " ")) do
      %{"powerup" => powerup} ->
        powerup |> String.trim() |> String.downcase() |> String.to_atom()

      nil ->
        nil
    end
  end

  defp answers(content, answers) do
    regex = ~r/# answers(?<answers>.*)#/iU

    case Regex.named_captures(regex, content |> String.replace("\n", " ")) do
      %{"answers" => answers} ->
        answers
        |> String.trim()
        |> String.split(["-", "*"], trim: true)
        |> Enum.with_index()

      nil ->
        nil
        answers(answers)
    end
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

  defp choose_file(category, position \\ 0) do
    path = "#{@qna_directory}/#{category}"
    {:ok, files} = File.ls(path)
    files = Enum.sort(files)
    count = Enum.count(files)
    index = count - 1

    position = file_position(position, index, count)

    Path.join(path, Enum.at(files, position))
  end

  defp file_position(position, index, count) when position > index do
    position - count
  end

  defp file_position(position, _index, _count), do: position

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
