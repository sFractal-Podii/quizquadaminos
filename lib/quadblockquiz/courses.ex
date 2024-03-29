defmodule Quadblockquiz.Courses do
  @courses_directory Application.compile_env!(:quadblockquiz, :base_questions_directory) <>
                       "/courses"

  def courses_list do
    @courses_directory
    |> File.ls!()
    |> Enum.filter(fn folder ->
      File.dir?("#{@courses_directory}/#{folder}") and
        not (File.ls!("#{@courses_directory}/#{folder}") |> Enum.empty?())
    end)
  end

  @doc """
  Gives the list of all the chapters in a course
  """
  def chapter_list(course) do
    "#{@courses_directory}/#{course}"
    |> File.ls!()
    |> Enum.filter(fn folder ->
      File.dir?("#{@courses_directory}/#{course}/#{folder}") and
        not (File.ls!("#{@courses_directory}/#{course}/#{folder}") |> Enum.empty?())
    end)
  end

  @doc """
  Gets the list of all files in side the course chapter
  """
  def question_list(course, chapter) do
    path = "#{@courses_directory}/#{course}/#{chapter}"
    File.ls!(path)
  end

  def questions(chapter, course) do
    for file <- question_list(course, chapter) do
      path = "#{@courses_directory}/#{course}/#{chapter}/#{file}"
      quiz(path)
    end
  end

  @doc """
  Returns HTML representation of the question
  """
  def question(course, chapter, file) do
    path = "#{@courses_directory}/#{course}/#{chapter}/#{file}"
    quiz(path)
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
