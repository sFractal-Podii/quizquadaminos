defmodule Quadquizaminos.Util do
  def date_count(date) do
    contest_date = Application.fetch_env!(:quadquizaminos, :contest_date)
    Date.diff(contest_date, DateTime.to_date(date))
  end

  def time_display(time_count) do
    count = time_count |> Integer.digits() |> Enum.count()
    if count == 1, do: "#{0}" <> "#{time_count}", else: "#{time_count}"
  end
end
