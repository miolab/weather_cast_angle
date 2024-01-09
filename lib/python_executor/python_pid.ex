defmodule PythonExecutor.PythonPid do
  @doc """
  Get ErlPort Python PID in application's environment.
  """
  @spec get_pid() :: pid()
  def get_pid(), do: Application.get_env(:weather_cast_angle, :python_pid)
end
