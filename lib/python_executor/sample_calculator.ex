defmodule PythonExecutor.SampleCalculator do
  @moduledoc """
  Sample module for calculation using erlport.
  """

  @doc """
  Add calculation sample.
  """
  @spec add(integer(), integer()) :: integer()
  def add(n1, n2) do
    python_pid = Application.get_env(:weather_cast_angle, :python_pid)

    :python.call(python_pid, :sample_calculator, :add, [n1, n2])
  end
end
