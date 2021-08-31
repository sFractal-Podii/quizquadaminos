defmodule Quadquizaminos.Courses do
  @courses_directory Application.get_env(:quadquizaminos, :courses_directory)

  def courses_list do
    @courses_directory
    |> File.ls!()
    |> Enum.filter(fn folder ->
      File.dir?("#{@courses_directory}/#{folder}") and
        not (File.ls!("#{@courses_directory}/#{folder}") |> Enum.empty?())
    end)

  end

  def chapter_list(course) do
    ("#{@courses_directory}/#{course}")
    |> File.ls!()
    |> Enum.filter(fn folder ->
      File.dir?("#{@courses_directory}/#{course}/#{folder}") and
        not (File.ls!("#{@courses_directory}/#{course}/#{folder}") |> Enum.empty?())
    end)
  end

  def questions(chapter,course) do
    path = "#{@courses_directory}/#{course}/#{chapter}"
    files = File.ls!(path)
    for file <- files do
      path = "#{@courses_directory}/#{course}/#{chapter}/#{file}"
      quiz(path)
    end
  end


  def quiz(file) do
    {:ok, content} = file |> File.read()
    [question, answers] = content |> String.split(~r/## answers/i)
    question = question_as_html(question)
    answers = answers(answers)
    [question, answers]
  end



  defp answers(answers) do
    answers
    |> String.split(["\n-", "\n*", "\n"], trim: true)
  end

  defp question_as_html(question) do
    {:ok, question, _} = Earmark.as_html(question)
    question |> String.replace("#", "")
  end

end
