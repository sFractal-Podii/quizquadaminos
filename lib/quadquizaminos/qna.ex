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

  ## Should this be done once at compile instead of every popup?
  def categories do
    @qna_directory
    |> File.ls!()
    |> Enum.filter(fn folder ->
      File.dir?("#{@qna_directory}/#{folder}") and
        not (File.ls!("#{@qna_directory}/#{folder}") |> Enum.empty?())
    end)
  end

  defp build do
    categories() |> Enum.random() |> build()
  end

  defp build(category, position \\ 0) do
    {:ok, content} = category |> choose_file(position) |> File.read()

    [question, answers] = content |> String.split(~r/## answers/i)

    %{
      question: question_as_html(question),
      answers: answers(content, answers),
      correct: correct_answer(answers),
      powerup: powerup(content),
      score: score(content)
    }
  end

  defp score(content) do
    regex = ~r/# score(?<score>.*)/i

    case named_captures(regex, content) do
      %{"score" => score} ->
        [score | _] = String.split(score, ~r/## powerup/i)

        score
        |> String.trim()
        |> String.split("-", trim: true)
        |> Enum.map(fn score -> score |> String.trim() |> String.split(":") |> List.to_tuple() end)
        |> Map.new()

      nil ->
        %{"Right" => "25", "Wrong" => "5"}
    end
  end

  defp powerup(content) do
    regex = ~r/# powerup(?<powerup>.*)/i

    case named_captures(regex, content) do
      %{"powerup" => powerup} ->
        powerup = powerup |> String.split(":") |> transform_powerup()

      nil ->
        nil
    end
  end

  defp transform_powerup(powerup) when is_binary(powerup) do
    powerup |> String.trim() |> String.downcase() |> String.to_atom()
  end

  defp transform_powerup([powerup | []]) do
    transform_powerup(powerup)
  end

  defp transform_powerup([powerup | [value]]) do
    {transform_powerup(powerup), String.trim(value)}
  end

  defp answers(content, answers) do
    regex = ~r/# answers(?<answers>.*)#/iUs

    case Regex.named_captures(regex, content) do
      %{"answers" => answers} ->
        answers(answers)

      nil ->
        answers(answers)
    end
  end

  defp answers(answers) do
    answers
    |> String.split(["\n-", "\n*", "\n"], trim: true)
    |> Enum.with_index()
  end

  defp named_captures(regex, content) do
    Regex.named_captures(regex, content |> String.replace("\n", " "))
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
    regex = ~r/(\n-|\n\*)/

    {_, correct} =
      Regex.scan(regex, answers, capture: :first)
      |> List.flatten()
      |> Enum.with_index()
      |> Enum.find(fn {k, _v} -> k == "\n*" end)

    correct |> to_string()
  end
end
