defmodule WeatherCastAngle.Utils.Collection do
  @moduledoc """
  Provides collection operations custom functions.
  """

  @doc """
  Converts the internal map keys of the given map from strings to atoms.

  The top-level keys are kept as strings, and the process of converting keys to atoms is performed only for the top-level keys of the map that are their values.
  """
  @spec normalize_inner_map_keys_to_atoms(
          %{String.t() => %{String.t() => term()}}
          | %{String.t() => %{atom: term()}}
        ) :: %{String.t() => %{atom: term()}} | {:error, String.t()}
  def normalize_inner_map_keys_to_atoms(map) when is_map(map) do
    Enum.map(map, fn {top_level_key, top_level_value} ->
      {
        top_level_key,
        Enum.reduce(
          top_level_value,
          %{},
          fn {key, value}, acc ->
            new_key = if is_binary(key), do: String.to_atom(key), else: key
            Map.put(acc, new_key, value)
          end
        )
      }
    end)
    |> Map.new()
  end

  def normalize_inner_map_keys_to_atoms(_), do: {:error, "The value must be Map."}
end
