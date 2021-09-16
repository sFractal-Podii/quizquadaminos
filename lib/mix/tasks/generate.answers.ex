defmodule Mix.Tasks.Gen.Answers do
  use Mix.Task

  @directories ["qna", "courses"]
  require Logger

  @shortdoc "Generates json file answers to the specified directory"
  def run(names) do
    validate_directory_name(names)

    names =
      case names do
        [] -> @directories
        names -> names
      end

    Enum.each(names, fn dir ->
      Logger.info("Generating answers for #{dir}..")

      incoming_answers = dir |> answer() |> Enum.into(%{}, fn {k, v} -> {k, convert(v)} end)

      file_path = dir <> "/answers.json"

      existing_answers =
        case File.read(file_path) do
          {:ok, content} -> Jason.decode!(content)
          _ -> %{}
        end

      new_answers = merge_answers(incoming_answers, existing_answers)
      content = new_answers |> Jason.encode!(pretty: true)
      :ok = File.write!(file_path, content)
      Logger.info("Answers written to #{file_path}")
    end)
  end

  defp merge_answers(map, map1) do
    Map.merge(map, map1, fn
      _k, v1, v2 when is_map(v2) ->
        merge_answers(v1, v2)

      _k, _v1, v2 ->
        v2
    end)
  end

  defp answer(dir) do
    if File.dir?(dir), do: answer(dir, :dir), else: answer(dir, :file)
  end

  defp answer(name, :file) do
    [file_name | _] = String.split(name, "/") |> Enum.reverse()

    answer =
      case question_type(name) do
        "free-form" -> "secret"
        "multi-choice" -> 0
      end

    {file_name, answer}
  end

  defp answer(name, :dir) do
    File.ls!(name)
    |> Enum.map(fn folder ->
      path = name <> "/" <> folder

      if File.dir?(path) do
        {folder, answer(path, :dir)}
      else
        answer(path, :file)
      end
    end)
  end

  defp question_type(filepath) do
    content = File.read!(filepath)

    header =
      case String.split(content, "---") do
        [header, _body] -> header
        [_body] -> ""
      end

    case Code.eval_string(header) do
      {%{type: type}, _} -> type
      _ -> "multi-choice"
    end
  end

  defp convert(value) when is_list(value) do
    Enum.into(value, %{}, fn {k, v} -> {k, convert(v)} end)
  end

  defp convert(value) do
    value
  end

  defp validate_directory_name([]), do: nil

  defp validate_directory_name(names) do
    Enum.each(names, fn name ->
      unless name in @directories do
        Logger.error(
          "\"#{name}\" is not a valid directory, use #{@directories |> Enum.join(", ")}"
        )
      end
    end)
  end
end
