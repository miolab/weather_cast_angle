defmodule SampleCalculator do
  @moduledoc """
  Sample module for calculation using erlport.
  """

  @doc """
  Add calculation sample.
  """
  @spec add(integer(), integer()) :: integer()
  def add(n1, n2) do
    {:ok, py} = :python.start([{:python_path, ~c"py_lib"}, {:python, ~c"python3"}])

    result = :python.call(py, :sample_calculator, :add, [n1, n2])
    :python.stop(py)

    result
  end
end
