defmodule WeatherCastAngle.Services.SampleCalculator do
  @moduledoc """
  Sample module for calculation using erlport.
  """

  @doc """
  Add calculation sample.
  """
  @spec sum_of_two_numbers(integer(), integer()) :: integer()
  def sum_of_two_numbers(n1, n2) do
    PythonManager.PythonExecutor.python_call(
      :sample_calculator,
      :sum_of_two_numbers,
      [n1, n2]
    )
  end
end
