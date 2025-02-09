defmodule WeatherCastAngle.Services.DatetimeProcessor do
  @moduledoc """
  Provides functions for processing datetime.
  This module mainly uses Asia/Tokyo timezone.
  """
  @asia_tokyo_timezone "Asia/Tokyo"

  @doc """
  Convert UNIX UTC timestamp to JST "yyyy-mm-dd HH" formatted datetime string.
  """
  @spec convert_unix_to_datetime_string(integer()) :: String.t()
  def convert_unix_to_datetime_string(unix_utc) do
    unix_utc
    |> Timex.from_unix()
    |> Timex.Timezone.convert(Timex.Timezone.get(@asia_tokyo_timezone))
    |> Timex.format!("{YYYY}-{0M}-{0D} {h24}")
  end

  @doc """
  Convert UNIX UTC timestamp to JST "HH:mm" formatted time string.
  """
  @spec convert_unix_to_hour_minute_format(integer()) :: String.t()
  def convert_unix_to_hour_minute_format(unix_utc) do
    unix_utc
    |> Timex.from_unix()
    |> Timex.Timezone.convert(Timex.Timezone.get(@asia_tokyo_timezone))
    |> Timex.format!("{h24}:{m}")
  end

  @doc """
  Convert date string "YYMMDD" to "YYYY-MM-DD" format.
  If a single-byte space is retained, it is filled with `0`.
  """
  @spec convert_date_format(String.t()) :: String.t()
  def convert_date_format(date_string) do
    date_string = String.replace(date_string, " ", "0")

    year =
      String.slice(date_string, 0, 2)
      |> String.to_integer()
      |> Kernel.+(2000)

    month = String.slice(date_string, 2, 2)
    day = String.slice(date_string, 4, 2)

    "#{year}-#{month}-#{day}"
  end

  @doc """
  Get current "Asia/Tokyo" date and return the YYYY-MM-DD formatted date string.
  """
  @spec get_current_date_string() :: String.t()
  def get_current_date_string() do
    Timex.format!(_get_current_date(), "{YYYY}-{0M}-{0D}")
  end

  defp _get_current_date(), do: Timex.now(@asia_tokyo_timezone)

  @doc """
  Return the date is current date or not.
  """
  @spec is_current_date(String.t()) :: boolean()
  def is_current_date(date), do: date == get_current_date_string()

  @doc """
  Get yesterday "Asia/Tokyo" date from current, and return the "YYYY-MM-DD" formatted date string.
  """
  @spec get_yesterday_string_from_current() :: String.t()
  def get_yesterday_string_from_current() do
    _get_current_date()
    |> Timex.shift(days: -1)
    |> Timex.format!("{YYYY}-{0M}-{0D}")
  end
end
