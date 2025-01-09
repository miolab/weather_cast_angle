defmodule WeatherCastAngle.Services.Forecast do
  @moduledoc """
  Provides functions about forecasts of weather, wind speed, etc. for the day and for the next several days.
  """
  alias WeatherCastAngle.Services.WeatherForecastHandler

  @doc """
  Fetches the forecast data for a specific location and date, and returns it as a map.
  """
  @spec get_forecast_by_date(String.t(), String.t()) ::
          %{
            # TODO: add more information later. (wind, temperature, etc.)
            weather_description: String.t()
          }
          | []
  def get_forecast_by_date(location_name, date) do
    forecast_map = WeatherForecastHandler.get_forecast_map_by_date(location_name, date)

    cond do
      forecast_map == [] ->
        []

      true ->
        %{
          # FIXME: mock result as sample
          weather_description: "Sample weather description"
        }
    end
  end
end
