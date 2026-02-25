defmodule Mix.Tasks.Validate.Answers do
  use Mix.Task

  require Logger

  @base_questions_directory Application.compile_env!(:quadblockquiz, :base_questions_directory)
                            |> to_string()

  @shortdoc "Checks that we do have answers for all the questions, and vice versa"
  def run(_) do
    answers_path = @base_questions_directory <> "/qna/answers.json"
    all_answers = File.read!(answers_path) |> Jason.decode!()
    all_files = Path.wildcard(@base_questions_directory <> "/qna/**/*/*.md")

    without_answers =
      Enum.map(all_files, fn filename ->
        ["qna" | rest] =
          filename
          |> String.split("/")
          |> Enum.drop_while(fn item -> item != "qna" end)

        case get_in(all_answers, rest) do
          nil -> rest
          _ -> nil
        end
      end)
      |> Enum.reject(&is_nil/1)
      |> Enum.map(fn file -> "qna" <> "/" <> Enum.join(file, "/") <> "\n" end)

    if Enum.empty?(without_answers) do
      Mix.shell().info("all answers are present.")
    else
      Mix.shell().error("""
      The following questions do not have answers: \n
      #{without_answers}
      """)
    end
  end
end
