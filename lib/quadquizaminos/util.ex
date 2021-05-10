defmodule Quadquizaminos.Util do
  def date_count(date) do
    contest_date = Application.fetch_env!(:quadquizaminos, :contest_date)
    Date.diff(contest_date, DateTime.to_date(date))
  end

  def count_display(digits) do
    count = digits |> Integer.digits() |> Enum.count()
    if count == 1, do: "#{0}" <> "#{digits}", else: "#{digits}"
  end
end
