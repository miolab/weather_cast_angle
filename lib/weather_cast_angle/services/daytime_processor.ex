defmodule WeatherCastAngle.Services.DaytimeProcessor do
  @doc """
  Get current date and return the YYYY-MM-DD formatted date string.
  """
  @spec get_current_date_string() :: String.t()
  def get_current_date_string() do
    Timex.format!(get_current_date(), "{YYYY}-{0M}-{0D}")
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

  defp get_current_date() do
    Timex.now("Asia/Tokyo")
  end
end
