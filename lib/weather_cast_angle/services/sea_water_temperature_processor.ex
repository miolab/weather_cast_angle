defmodule WeatherCastAngle.Services.SeaWaterTemperatureProcessor do
  @doc """
  Generate a Map consisting of date and temperature.
  """
  @spec previous_days_records(String.t()) :: %{String.t() => float()}
  def previous_days_records(records) do
    records
    |> String.split("\n", trim: true)
    |> Enum.reverse()
    |> _drop_headline()
    |> Enum.take(3)
    |> Enum.map(&_extract_date_and_temperature/1)
    |> Enum.map(&_round_temperature/1)
    |> Enum.into(%{})
  end

  defp _drop_headline(line) do
    # If the first line does NOT begin with a 4-digit number, drop the first line.
    cond do
      Regex.match?(~r/^\d{4}/, line |> hd) -> line
      true -> Enum.drop(line, 1)
    end
  end

  defp _extract_date_and_temperature(line) do
    # Extract the date and temperature from a string like "2024,01,20,602,P, 15.83" and convert to a tuple such as {"2024-01-20", "15.83"}.
    # The purpose is intended to be stored in a keyword list.
    [yyyy, mm, dd | _] = String.split(line, ",")

    date =
      Date.from_iso8601!("#{yyyy}-#{mm}-#{dd}")
      |> Date.to_iso8601()

    temperature =
      line
      |> String.split(",")
      |> List.last()
      |> String.trim()

    {date, temperature}
  end

  defp _round_temperature({date, temperature_string}) do
    temperature =
      temperature_string
      |> String.to_float()
      |> Float.round(1)

    {date, temperature}
  end

  @doc """
  Converts a map of date-temperature pairs into a sorted keyword list,
  maintaining the descending order of dates.
  """
  @spec convert_to_sorted_keyword_list(%{String.t() => float()}) :: [{String.t(), float()}]
  def(convert_to_sorted_keyword_list(previous_temperatures_map)) do
    previous_temperatures_map
    |> Enum.map(fn {key, value} -> {key, value} end)
    |> Enum.sort_by(
      fn {key, _} -> key end,
      :desc
    )
  end
end
