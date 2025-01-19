defmodule WeatherCastAngle.Services.TideNameClassifier do
  @moduledoc """
  Returns Tide Name based on the ecliptic longitude difference between the sun and the moon using erlport and Python script.
  """
  alias PythonManager.PythonExecutor

  @doc """
  Get the ecliptic longitude difference.
  """
  @spec get_ecliptic_longitude_difference(String.t()) :: String.t()
  def get_ecliptic_longitude_difference(date) do
    date
    |> _get_ecliptic_longitude_difference_using_python()
    |> _classify_tide_name()
  end

  defp _get_ecliptic_longitude_difference_using_python(date) do
    PythonExecutor.python_call(
      :ecliptic_longitude_difference_calculator,
      :calculate_ecliptic_longitude_difference,
      [date]
    )
  end

  # Classify the tide name based on the ecliptic longitude difference.
  @spec _classify_tide_name(non_neg_integer()) :: String.t()
  defp _classify_tide_name(angle)
       when angle >= 343 or angle < 31 or (angle >= 163 and angle < 211),
       do: "大潮"

  defp _classify_tide_name(angle)
       when (angle >= 31 and angle < 67) or (angle >= 127 and angle < 163) or
              (angle >= 211 and angle < 247) or (angle >= 307 and angle < 343),
       do: "中潮"

  defp _classify_tide_name(angle)
       when (angle >= 67 and angle < 103) or (angle >= 247 and angle < 283),
       do: "小潮"

  defp _classify_tide_name(angle)
       when (angle >= 103 and angle < 115) or (angle >= 283 and angle < 295),
       do: "長潮"

  defp _classify_tide_name(angle)
       when (angle >= 115 and angle < 127) or (angle >= 295 and angle < 307),
       do: "若潮"

  defp _classify_tide_name(_angle), do: "-"
end
