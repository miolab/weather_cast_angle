defmodule WeatherCastAngle.Utils.Validation do
  @moduledoc """
  Provides custom validation functions for various types of input value.
  """

  @doc """
  Validates that the given value is in the array.

  ## Examples

      iex> Utils.Validation.validate_in_array("ab", ["ab", "cd", "ef"])
      :ok

      iex> Utils.Validation.validate_in_array("z", ["ab", "cd", "ef"])
      {:error, "Value not found in array"}

      iex> Utils.Validation.validate_in_array("ab", "abcde")
      {:error, "abcde must be a list"}
  """
  @spec validate_in_array(term(), list(term())) :: :ok | {:error, String.t()}
  def validate_in_array(value, array) when is_list(array) do
    case value in array do
      true -> :ok
      false -> {:error, "Value not found in array"}
    end
  end

  def validate_in_array(_, array), do: {:error, "#{array} must be a list"}

  @doc """
  Validates that the given value matches the `YYYY-MM-DD` date format.

  ## Examples

      iex> Utils.Validation.validate_date_format("2024-01-01")
      :ok

      iex> Utils.Validation.validate_date_format("2024-1-1")
      {:error, "Invalid date format"}
  """
  @spec validate_date_format(String.t()) :: :ok | {:error, String.t()}
  def validate_date_format(value) do
    case Regex.match?(~r/^\d{4}-\d{2}-\d{2}$/, value) do
      true -> :ok
      false -> {:error, "Invalid date format"}
    end
  end

  @doc """
  Validates that the given value consists of lowercase alphanumeric characters and is within a specific range of characters long.

  ## Examples

      iex> Utils.Validation.validate_lowercase_alphabetic_length("abc", 2, 3)
      :ok

      iex> Utils.Validation.validate_lowercase_alphabetic_length("a", 2, 3)
      {:error, "The value must be at least 2 characters long."}

      iex> Utils.Validation.validate_lowercase_alphabetic_length("abcde", 2, 3)
      {:error, "The value must be no more than 3 characters long."}
  """
  @spec validate_lowercase_alphabetic_length(
          String.t(),
          pos_integer(),
          pos_integer()
        ) :: :ok | {:error, String.t()}
  def validate_lowercase_alphabetic_length(value, min, max)
      when 1 <= min and min <= max and is_integer(min) and is_integer(max) do
    cond do
      String.length(value) < min ->
        {:error, "The value must be at least #{min} characters long."}

      String.length(value) > max ->
        {:error, "The value must be no more than #{max} characters long."}

      Regex.match?(~r/^[a-z]+$/, value) ->
        :ok

      true ->
        {:error, "The value must consist of lowercase alphabetic characters only."}
    end
  end

  def validate_lowercase_alphabetic_length(_, _, _),
    do: {
      :error,
      "Invalid parameters: min must be at least 1 and max must be equal to or greater integer than min."
    }
end
