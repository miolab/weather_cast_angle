defmodule WeatherCastAngle.Services.DaytimeProcessor do
  @doc """
  Get current date and return the YYYY-MM-DD formatted date string.
  """
  @spec get_current_date_string() :: String.t()
  def get_current_date_string() do
    Timex.format!(get_current_date(), "{YYYY}-{0M}-{0D}")
  end

  defp get_current_date() do
    Timex.now("Asia/Tokyo")
  end
end
