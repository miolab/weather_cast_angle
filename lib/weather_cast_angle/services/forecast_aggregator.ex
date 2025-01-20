defmodule WeatherCastAngle.Services.ForecastAggregator do
  @moduledoc """
  Aggregate functions about forecasts of weather, wind speed, etc. for the day and for the next several days.
  """
  alias WeatherCastAngle.Utils
  # alias WeatherCastAngle.Services.WeatherForecastHandler
  alias WeatherCastAngle.Services.MoonStatusCalculator
  alias WeatherCastAngle.Services.TideNameClassifier

  @doc """
  Fetches the forecast data for a specific location and date, and returns it as a map.
  """
  @spec get_forecast_by_date(String.t(), String.t()) ::
          %{
            # TODO: add more information later. (wind, temperature, etc.)
            weather_description: String.t(),
            moon_age: float(),
            moon_phase: String.t(),
            tide_name: String.t()
          }
          | []
  def get_forecast_by_date(location_name, date) do
    # forecast_map = WeatherForecastHandler.get_forecast_map_by_date(location_name, date)

    # cond do
    # forecast_map == [] ->
    #   []

    # true ->
    %{
      # FIXME: mock result as sample
      weather_description: "Sample weather description",
      moon_age: _fetch_moon_status(date, location_name) |> Map.get("moon_age"),
      moon_phase: _fetch_moon_status(date, location_name) |> Map.get("moon_phase"),
      tide_name: _get_tide_name_by_date(date)
    }

    # end
  end

  defp _fetch_moon_status(date, location_name) do
    location_map = Utils.Locations.get_location_map_by_name(location_name)

    latitude = location_map |> Map.get(:latitude)
    longitude = location_map |> Map.get(:longitude)

    %{
      "moon_age" => MoonStatusCalculator.get_moon_age(date, latitude, longitude),
      "moon_phase" => MoonStatusCalculator.get_moon_phase(date, latitude, longitude)
    }
  end

  defp _get_tide_name_by_date(date),
    do: TideNameClassifier.get_ecliptic_longitude_difference(date)
end
