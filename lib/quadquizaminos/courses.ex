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



end
