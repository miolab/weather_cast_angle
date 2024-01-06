defmodule WeatherCastAngle.Services.WeatherForecastHandler do
  @moduledoc """
  Provides functions for handling weather forecast HTTP request responses.
  """
  @forecast_url "https://api.openweathermap.org/data/2.5/forecast"

  # TODO: fix to private
  def get_weather_forecast(location_name) do
    cache_key = location_name <> "_weather_forecast"

    WeatherCastAngle.Services.WeatherDataProcessor.get_open_weather_data(
      location_name,
      cache_key,
      @forecast_url
    )
  end

  @doc """
  Extracts and transforms specific weather forecast.
  """
  @spec extract_weather_forecast(String.t()) :: map()
  def extract_weather_forecast(location_name) do
    forecast_maps = get_weather_forecast(location_name)["list"]

    Enum.reduce(forecast_maps, %{}, fn forecast_map, acc ->
      weather_map = Enum.at(forecast_map["weather"], 0, %{})

      Map.put(
        acc,
        forecast_map["dt"]
        |> WeatherCastAngle.Services.DatetimeProcessor.convert_unix_to_datetime_string(),
        %{
          weather_description: weather_map |> Map.get("description", ""),
          weather_main: weather_map |> Map.get("main", ""),
          wind_speed: forecast_map["wind"]["speed"],
          main_temp:
            forecast_map["main"]["temp"]
            |> WeatherCastAngle.Services.WeatherDataProcessor.kelvin_to_celsius_temperature(),
          main_humidity: forecast_map["main"]["humidity"]
        }
      )
    end)
  end
end
