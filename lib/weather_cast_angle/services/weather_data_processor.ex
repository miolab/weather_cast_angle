defmodule WeatherCastAngle.Services.WeatherDataProcessor do
  @moduledoc """
  Provides various functions for processing weather data.
  """
  alias WeatherCastAngle.Utils
  alias WeatherCastAngle.Cache

  @open_weather_api_key System.get_env("OPEN_WEATHER_API_KEY")

  @spec get_open_weather_data(String.t(), String.t(), String.t()) :: map()
  def get_open_weather_data(location_name, cache_key, target_url) do
    cached_value = Cache.get_cache(cache_key)

    case cached_value do
      nil ->
        res =
          HTTPoison.get(target_url, [],
            params: _query_parameters_for_get_weather_data(location_name)
          )

        case res do
          {:ok, %HTTPoison.Response{body: response_body}} ->
            Cache.put_cache(cache_key, response_body, 5)

            response_body |> Jason.decode!()

          {:error, %HTTPoison.Error{reason: reason}} ->
            %{"Error" => reason}
        end

      _ ->
        cached_value |> Jason.decode!()
    end
  end

  defp _query_parameters_for_get_weather_data(location_name) do
    location_map = Utils.Locations.get_location_map_by_name(location_name)

    %{
      lat: location_map |> Map.get(:latitude) |> Float.to_string(),
      lon: location_map |> Map.get(:longitude) |> Float.to_string(),
      lang: "ja",
      APPID: @open_weather_api_key
    }
  end

  @doc """
  Converts a temperature from Kelvin to Celsius.
  """
  @spec kelvin_to_celsius_temperature(float()) :: integer()
  def kelvin_to_celsius_temperature(kelvin) do
    (kelvin - 273.15)
    |> Float.round()
    |> trunc()
  end

  @doc """
  Rounds the given wind speed to the nearest integer from float.
  If an integer is given as an argument, it is returned as is.
  """
  @spec round_wind_speed(float() | non_neg_integer()) :: non_neg_integer()
  def round_wind_speed(wind_speed) when is_float(wind_speed), do: round(wind_speed)
  def round_wind_speed(wind_speed) when is_integer(wind_speed), do: wind_speed

  @doc """
  Convert the wind direction angle integer to an 8 wind direction notation flag.
  """
  @spec wind_direction_flag(non_neg_integer()) :: atom() | nil
  def wind_direction_flag(degrees)
      when is_integer(degrees) and (degrees >= 0 and degrees <= 359) do
    cond do
      degrees < 22.5 or degrees >= 337.5 -> :north
      degrees < 67.5 -> :northeast
      degrees < 112.5 -> :east
      degrees < 157.5 -> :southeast
      degrees < 202.5 -> :south
      degrees < 247.5 -> :southwest
      degrees < 292.5 -> :west
      degrees < 337.5 -> :northwest
    end
  end

  def wind_direction_flag(_), do: nil

  @doc """
  Convert the wind direction angle flag to an 8 wind direction notation in Japanese.
  """
  @spec wind_direction(non_neg_integer()) :: String.t()
  def wind_direction(degrees) do
    cond do
      wind_direction_flag(degrees) == :north -> "北"
      wind_direction_flag(degrees) == :northeast -> "北東"
      wind_direction_flag(degrees) == :east -> "東"
      wind_direction_flag(degrees) == :southeast -> "南東"
      wind_direction_flag(degrees) == :south -> "南"
      wind_direction_flag(degrees) == :southwest -> "南西"
      wind_direction_flag(degrees) == :west -> "西"
      wind_direction_flag(degrees) == :northwest -> "北西"
      true -> ""
    end
  end

  @doc """
  Converts a float value to a percentage.
  This function is intended for use in the calculation of precipitation probability.
  """
  @spec convert_to_percentage(float | 0 | 1) :: non_neg_integer()
  def convert_to_percentage(probability) do
    cond do
      is_integer(probability) or
          Float.floor(probability, 1) == probability ->
        probability * 100

      true ->
        probability
        |> Float.round(1)
        |> Kernel.*(100)
        |> trunc()
    end
  end
end
