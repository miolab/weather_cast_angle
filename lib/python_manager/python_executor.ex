defmodule PythonManager.PythonExecutor do
  @doc """
  ErlPort `:python.call` wrapper.
  """
  @spec python_call(python_module :: atom(), python_function :: atom(), args :: list()) :: term()
  def python_call(python_module, python_function, args) do
    :python.call(
      python_pid(),
      python_module,
      python_function,
      args
    )
  end

  # Get ErlPort Python PID in application's environment.
  defp python_pid(), do: Application.get_env(:weather_cast_angle, :python_pid)
end
