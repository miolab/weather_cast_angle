defmodule WeatherCastAngle.Services.MoonStatusCalculator do
  @moduledoc """
  Calculates Various Moon Status using erlport.
  """

  @doc """
  Calculates the moon phase and returns it's notation.
  """
  @spec get_moon_phase(String.t(), float(), float()) :: String.t()
  def get_moon_phase(date, latitude, longitude) do
    PythonManager.PythonExecutor.python_call(
      :moon_status_calculator,
      :get_moon_phase,
      [date, latitude, longitude]
    )
    |> to_string()
  end
end
