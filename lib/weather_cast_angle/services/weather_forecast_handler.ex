defmodule WeatherCastAngle.Services.WeatherForecastHandler do
  @moduledoc """
  Provides functions for handling weather forecast HTTP request responses.
  """
  @forecast_url "https://api.openweathermap.org/data/2.5/forecast"

  def get_weather_forecast(location_name) do
    cache_key = location_name <> "_weather_forecast"

    WeatherCastAngle.Services.WeatherDataProcessor.get_open_weather_data(
      location_name,
      cache_key,
      @forecast_url
    )
  end
end
