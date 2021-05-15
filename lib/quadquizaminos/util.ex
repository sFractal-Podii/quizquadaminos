defmodule Quadquizaminos.Util do
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

  def to_human_time(seconds) do
    days = div(seconds, 86_400)
    rem = rem(seconds, 86_400)
    hours = div(rem, 3600)
    rem = rem(rem, 3600)
    minutes = div(rem, 60)
    rem = rem(rem, 60)
    seconds = div(rem, 1)
    {days, hours, minutes, seconds}
  end
end
