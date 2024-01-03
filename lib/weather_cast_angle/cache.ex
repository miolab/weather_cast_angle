defmodule WeatherCastAngle.Cache do
  @moduledoc """
  Provides caching functionality for the application using Cachex.

  This module offers methods to store and retrieve data from a cache,
  abstracting the underlying Cachex implementation.
  """

  @doc """
  Retrieves a value from the cache based on the given key.

  This function looks up the cache for the specified key and returns the associated value if it exists.
  If the key is not found in the cache, it returns `nil`.
  """
  @spec get_cache(String.t()) :: String.t() | nil
  def get_cache(key) do
    case Cachex.get(:common_cache, key) do
      {:ok, nil} -> nil
      {:ok, value} -> value
      _ -> nil
    end
  end

  @doc """
  Puts a value in the cache under the specified key.

  This function stores a given value in the cache associated with the specified key.
  The stored value will have a time-to-live (TTL) of specified minutes.
  """
  @spec put_cache(String.t(), String.t(), non_neg_integer()) :: {:ok, true}
  def put_cache(key, value, minutes \\ 2) do
    Cachex.put(
      :common_cache,
      key,
      value,
      ttl: :timer.minutes(minutes)
    )
  end
end
