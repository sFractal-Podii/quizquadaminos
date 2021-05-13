defmodule Quadquizaminos.Util do
  def date_count(date) do
    contest_date = Application.fetch_env!(:quadquizaminos, :contest_date)
    Date.diff(contest_date, DateTime.to_date(date))
  end

  def count_display(digits) do
    count = digits |> Integer.digits() |> Enum.count()
    if count == 1, do: "#{0}" <> "#{digits}", else: "#{digits}"
  end

  def datetime_to_time(datetime) do
    datetime
    |> DateTime.truncate(:second)
    |> DateTime.to_time()
  end

  def datetime_to_date(datetime) do
    datetime
    |> DateTime.to_date()
  end
end
