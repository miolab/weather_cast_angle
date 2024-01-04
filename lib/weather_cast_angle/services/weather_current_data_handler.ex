defmodule WeatherCastAngle.Services.WeatherCurrentDataHandler do
  @moduledoc """
  Provides functions for handling current weather data HTTP request responses.
  """
  @current_weather_url "https://api.openweathermap.org/data/2.5/weather"

  def get_current_weather_data(location_name) do
    cache_key = location_name <> "_current_weather"

    WeatherCastAngle.Services.WeatherDataProcessor.get_open_weather_data(
      location_name,
      cache_key,
      @current_weather_url
    )
  end

  @doc """
  Extracts and transforms specific weather data from a given map.
  """
  @spec extract_current_weather(map()) :: %{
          dt: String.t(),
          weather_description: String.t(),
          weather_main: String.t(),
          wind_speed: float(),
          main_temp: float(),
          main_humidity: integer()
        }
  def extract_current_weather(current_weather_response_map)
      when is_map_key(current_weather_response_map, "Error"),
      do: _extract_current_weather_default()

  def extract_current_weather(current_weather_response_map) do
    required_keys = ["dt", "main", "wind", "weather"]

    cond do
      _does_any_key_missing(current_weather_response_map, required_keys) ->
        _extract_current_weather_default()

      true ->
        weather_map =
          current_weather_response_map["weather"] |> List.first()

        %{
          dt:
            current_weather_response_map["dt"]
            |> WeatherCastAngle.Services.DatetimeProcessor.convert_unix_to_datetime_string(),
          weather_description: weather_map |> Map.get("description"),
          weather_main: weather_map |> Map.get("main"),
          wind_speed: current_weather_response_map["wind"]["speed"],
          main_temp:
            current_weather_response_map["main"]["temp"]
            |> WeatherCastAngle.Services.WeatherDataProcessor.kelvin_to_celsius_temperature(),
          main_humidity: current_weather_response_map["main"]["humidity"]
        }
    end
  end

  defp _extract_current_weather_default() do
    %{
      dt: "",
      weather_description: "",
      weather_main: "",
      wind_speed: 0.0,
      main_temp: 0.0,
      main_humidity: 0
    }
  end

  defp _does_any_key_missing(map, keys) do
    Enum.any?(keys, fn key -> !Map.has_key?(map, key) end)
  end
end
