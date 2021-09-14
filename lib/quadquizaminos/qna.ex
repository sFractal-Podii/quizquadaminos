defmodule Quadquizaminos.QnA do
  @qna_directory Application.compile_env(:quadquizaminos, :qna_directory)

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

  @doc """
  Removes categories that are already answered
  """
  def remove_used_categories(categories) do
    categories
    |> Enum.reject(fn {k, v} -> maximum_category_position(k) == v end)
    |> Enum.into(%{})
    |> Map.keys()
  end

  def maximum_category_position(category) do
    path = "#{@qna_directory}/#{category}"
    {:ok, files} = File.ls(path)
    Enum.count(files)
  end

  @doc """
  Validates format of the markdown files
  """
  def validate_files do
    folders = File.ls!("qna")

    for folder <- folders,
        path = "qna/" <> folder,
        File.dir?(path),
        File.ls!(path) != [],
        position <- 0..(Enum.count(File.ls!(path)) ) do
      try do
        Quadquizaminos.QnA.question(folder, position)
      rescue
        e ->
          require Logger
          Logger.error("Could not parse #{choose_file(folder, position)}")
          reraise e, __STACKTRACE__
      end
    end

    :ok
  end

  defp build do
    categories() |> Enum.random() |> build()
  end

  defp build(cat, position \\ 0)

  defp build(category, position) do
    {:ok, content} = category |> choose_file(position) |> File.read()

    [header, body] =
      case String.split(content, "---") do
        [_header, _body] = result -> result
        [body] -> [nil, body]
      end

    [question, choices] = body |> String.split(~r/## answers/i)

    %Quadquizaminos.Questions.Question{}
    |> struct(%{
      question: question_as_html(question),
      choices: choices(content, choices),
      correct: correct_answer(choices, category),
      powerup: powerup(content),
      score: score(content),
      type: header(header).type
    })
  end

  defp header(nil), do: %{type: nil}

  defp header(header) do
    {result, _} = Code.eval_string(header)
    result
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
        powerup |> String.trim() |> String.downcase() |> String.to_atom()

      nil ->
        nil
    end
  end

  defp choices(content, answers) do
    regex = ~r/# answers(?<answers>.*)#/iUs

    case Regex.named_captures(regex, content) do
      %{"answers" => answers} ->
        choices(answers)

      nil ->
        choices(answers)
    end
  end

  defp choices(answers) do
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

  defp choose_file(category, position) do
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

  defp correct_answer(answers, "bonus") do
    regex = ~r/\n\*(.+?)\n/

    [[_, clue] | _t] = Regex.scan(regex, answers)
    clue = String.trim(clue)

    Application.get_env(:quadquizaminos, :bonus_answers)[String.to_atom(clue)]
  end

  defp correct_answer(answers, _category) do
    regex = ~r/(\n-|\n\*)/

    {_, correct} =
      Regex.scan(regex, answers, capture: :first)
      |> List.flatten()
      |> Enum.with_index()
      |> Enum.find(fn {k, _v} -> k == "\n*" end)

    correct |> to_string()
  end
end
