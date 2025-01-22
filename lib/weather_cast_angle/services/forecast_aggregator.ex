defmodule WeatherCastAngle.Services.ForecastAggregator do
  @moduledoc """
  Aggregate functions about forecasts of weather, wind speed, etc. for the day and for the next several days.
  """
  alias WeatherCastAngle.Utils
  alias WeatherCastAngle.Services.DatetimeProcessor
  alias WeatherCastAngle.Services.WeatherCurrentDataHandler
  alias WeatherCastAngle.Services.WeatherForecastHandler
  alias WeatherCastAngle.Services.MoonStatusCalculator
  alias WeatherCastAngle.Services.TideNameClassifier

  @doc """
  Fetches the forecast data for a specific location and date, and returns it as a map.
  """
  @spec get_forecast_by_date(String.t(), String.t()) ::
          %{
            # TODO: add more information later. (wind, temperature, etc.)
            weather_description: String.t(),
            weather_icon_uri: String.t(),
            wind_deg: String.t(),
            wind_speed: float() | String.t(),
            moon_age: float(),
            moon_phase: String.t(),
            tide_name: String.t()
          }
  def get_forecast_by_date(location_name, date) do
    weather_forecast_summary_map = _get_weather_forecast_summary_map(location_name, date)

    %{
      weather_description: weather_forecast_summary_map |> Map.get(:weather_description, "-"),
      weather_icon_uri: weather_forecast_summary_map |> Map.get(:weather_icon_uri, ""),
      wind_deg: weather_forecast_summary_map |> Map.get(:wind_deg, ""),
      wind_speed: weather_forecast_summary_map |> Map.get(:wind_speed, "-"),
      moon_age: _fetch_moon_status(date, location_name) |> Map.get("moon_age"),
      moon_phase: _fetch_moon_status(date, location_name) |> Map.get("moon_phase"),
      tide_name: _get_tide_name_by_date(date)
    }
  end

  defp _get_weather_forecast_summary_map(location_name, date) do
    # TODO: controller から移行して持ってくる
    case DatetimeProcessor.is_current_date(date) do
      true ->
        _current_weather_summary_map(location_name)

      false ->
        _weather_forecast_summary_map(location_name, date)
    end
  end

  defp _current_weather_summary_map(location_name),
    do: WeatherCurrentDataHandler.extract_current_weather(location_name)

  defp _weather_forecast_summary_map(location_name, date) do
    forecast_summary_map = WeatherForecastHandler.get_forecast_map_by_date(location_name, date)

    cond do
      forecast_summary_map == [] ->
        %{}

      Enum.any?(forecast_summary_map, fn map -> Map.has_key?(map, "12") end) ->
        # TODO: 暫定で各日12時台の予報を取得している
        forecast_summary_map
        |> Enum.find(fn map -> Map.has_key?(map, "12") end)
        |> Map.get("12")

      true ->
        # TODO: 暫定で最後の要素を取得している
        last_map = List.last(forecast_summary_map)
        last_key = last_map |> Map.keys() |> List.last()
        Map.get(last_map, last_key)
    end
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
