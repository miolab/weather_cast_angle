defmodule WeatherCastAngle.Services.MoonStatusCalculator do
  @moduledoc """
  Calculates Various Moon Status using erlport and Python script.
  """

  @doc """
  Get the moon phase status.
  If it is neither a Full nor a New moon, returns a empty character.
  """
  @spec get_moon_phase(String.t(), float(), float()) :: String.t()
  def get_moon_phase(date, latitude, longitude) do
    phase_degree = _get_moon_phase_degree_using_python(date, latitude, longitude)

    cond do
      phase_degree < 0.25 ->
        "new-moon"

      phase_degree > 0.75 ->
        "full-moon"

      true ->
        ""
    end
  end

  defp _get_moon_phase_degree_using_python(date, latitude, longitude) do
    PythonManager.PythonExecutor.python_call(
      :moon_status_calculator,
      :get_moon_phase,
      [date, latitude, longitude]
    )
  end

  @doc """
  Get the moon age.
  """
  @spec get_moon_age(String.t(), float(), float()) :: float()
  def get_moon_age(date, latitude, longitude) do
    _get_moon_age_using_python(date, latitude, longitude)
    |> Float.round(1)
  end

  defp _get_moon_age_using_python(date, latitude, longitude) do
    PythonManager.PythonExecutor.python_call(
      :moon_status_calculator,
      :calculate_moon_age,
      [date, latitude, longitude]
    )
  end
end
