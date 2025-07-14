# send all shell output to this process
# for more visit https://jc00ke.com/2017/04/05/testing-elixir-mix-tasks/
Mix.shell(Mix.Shell.Process)

defmodule Mix.Tasks.Validate.AnswersTest do
  use ExUnit.Case, async: true

  @base_questions_directory Application.compile_env!(:quadblockquiz, :base_questions_directory)
                            |> to_string()
  @answers_path @base_questions_directory <> "/qna/answers.json"

  test "fails if file is not present" do
    File.rm(@answers_path)

    assert_raise(File.Error, fn ->
      Mix.Tasks.Validate.Answers.run([])
    end)
  end

  test "fails when answers are missing" do
    Mix.Tasks.Gen.Answers.run([])
    File.write(@answers_path, "{}")
    Mix.Tasks.Validate.Answers.run([])
    assert_received {:mix_shell, :error, [error]}

    assert error =~ "The following questions do not have answers: "
  end

  test "passes if all answers are present" do
    Mix.Tasks.Gen.Answers.run([])
    Mix.Tasks.Validate.Answers.run([])

    assert_received {:mix_shell, :info, [info]}

    assert info == "all answers are present."
  end
end
