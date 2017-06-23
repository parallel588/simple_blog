defmodule SimpleBlog.Web.PostView do
  use SimpleBlog.Web, :view
  use Timex

  def date_format(date), do: date_format date, "%d %b %Y"

  def date_format(date = %Ecto.DateTime{}, format_string) do
    Ecto.DateTime.to_iso8601(date)
    |> date_formatter(format_string)
  end
  def date_format(date = %Ecto.Date{}, format_string) do
    << Ecto.Date.to_iso8601(date) <> "T00:00:00Z" >>
    |> date_formatter(format_string)
  end

  def date_format(date = %NaiveDateTime{}, format_string) do
    Timex.format!(date, "%B %d %Y", :strftime)
  end
  def date_format(_, _format), do: ""

  defp date_formatter(date, format_string) do
    date
    |> DateFormat.parse!("{ISOz}")
    |> DateFormat.format!(format_string, :strftime)
  end
end
