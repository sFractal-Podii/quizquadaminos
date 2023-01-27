defmodule Mix.Tasks.Validate.Answers do
  use Mix.Task

  require Logger

  @shortdoc "Checks that we do have answers for all the questions, and vice versa"
  def run(_) do
    all_answers = File.read!("qna/answers.json") |> Jason.decode!()
    all_files = Path.wildcard("qna/**/*/*.md")

    without_answers =
      Enum.map(all_files, fn filename ->
        ["qna" | rest] = String.split(filename, "/")

        case get_in(all_answers, rest) do
          nil -> rest
          _ -> nil
        end
      end)
      |> Enum.reject(&is_nil/1)
      |> Enum.map(fn file -> "qna" <> "/" <> Enum.join(file, "/") <> "\n" end)

    if Enum.count(without_answers) > 0 do
      """
      The following questions do not have answers: \n
      #{without_answers}
      """
      |> Mix.shell().error()

      exit({:shutdown, 1})
    end
  end
end
