defmodule WeatherCastAngle.Utils.Validation do
  @moduledoc """
  Provides custom validation functions for various types of input value.
  """

  @doc """
  Validates that the given value matches the `YYYY-MM-DD` date format.
  """
  @spec validate_date_format(String.t()) :: :ok | {:error, String.t()}
  def validate_date_format(value) do
    case Regex.match?(~r/^\d{4}-\d{2}-\d{2}$/, value) do
      true -> :ok
      false -> {:error, "Invalid date format"}
    end
  end
end
