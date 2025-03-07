defmodule WeatherCastAngle.Services.ForecastAggregator do
  @moduledoc """
  Aggregate functions about forecasts of weather, wind speed, etc. for the day and for the next several days.
  """
  alias WeatherCastAngle.Utils
  alias WeatherCastAngle.Utils.DatetimeProcessor
  alias WeatherCastAngle.Services.WeatherCurrentDataHandler
  alias WeatherCastAngle.Services.WeatherForecastHandler
  alias WeatherCastAngle.Services.MoonStatusCalculator
  alias WeatherCastAngle.Services.TideNameClassifier

  @typep forecast_by_date_t :: %{
           date: String.t(),
           weather_description: String.t(),
           weather_icon_uri: String.t(),
           wind_deg: String.t(),
           wind_speed: float() | String.t(),
           main_temp: integer(),
           main_humidity: integer(),
           moon_age: float(),
           moon_phase: String.t(),
           tide_name: String.t(),
           sunrise: String.t(),
           sunset: String.t()
         }

  @doc """
  Fetches the forecast data for a specific location and date, and returns it as a map.

  The returned map has the following structure:
  - `date`: Target forecast date in YYYY-MM-DD format.
  - `weather_description`: Description of the weather (e.g., "厚い雲").
  - `weather_icon_uri`: URI for the weather icon.
  - `wind_deg`: Wind direction in degrees as a string.
  - `wind_speed`: Wind speed as a float or string (e.g., "5.5" or 5.5).
  - `main_temp`: Main temperature in Celsius.
  - `main_humidity`: Humidity percentage.
  - `moon_age`: Moon age in days as a float.
  - `moon_phase`: Description of the moon phase.
  - `tide_name`: Name of the tide (e.g., "大潮").
  - `sunrise`: Sunrise time in HH:MM format.
  - `sunset`: Sunset time in HH:MM format.
  """
  @spec get_forecast_by_date(String.t(), String.t()) :: forecast_by_date_t()
  def get_forecast_by_date(location_name, date) do
    weather_forecast_summary_map = _get_weather_forecast_summary_map(location_name, date)

    %{
      date: date,
      weather_description: weather_forecast_summary_map |> Map.get(:weather_description, "-"),
      weather_icon_uri: weather_forecast_summary_map |> Map.get(:weather_icon_uri, ""),
      wind_deg: weather_forecast_summary_map |> Map.get(:wind_deg, ""),
      wind_speed: weather_forecast_summary_map |> Map.get(:wind_speed, "-"),
      main_temp: weather_forecast_summary_map |> Map.get(:main_temp, "-"),
      main_humidity: weather_forecast_summary_map |> Map.get(:main_humidity, "-"),
      moon_age: _fetch_moon_status(date, location_name) |> Map.get("moon_age"),
      moon_phase: _fetch_moon_status(date, location_name) |> Map.get("moon_phase"),
      tide_name: _get_tide_name_by_date(date),
      sunrise: weather_forecast_summary_map |> Map.get(:sunrise, "-"),
      sunset: weather_forecast_summary_map |> Map.get(:sunset, "-")
    }
  end

  @doc """
  Gets recent forecasts, from current date.
  """
  @spec get_recent_forecasts(String.t()) :: [forecast_by_date_t()]
  def get_recent_forecasts(location_name) do
    days_range = 0..3

    days_range
    |> Enum.map(fn days -> DatetimeProcessor.shift_date_from_current(days) end)
    |> Enum.map(fn date -> get_forecast_by_date(location_name, date) end)
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
        |> Map.merge(WeatherForecastHandler.get_sunrise_and_sunset_information_map(location_name))

      true ->
        # TODO: 暫定で最後の要素を取得している
        last_map = List.last(forecast_summary_map)
        last_key = last_map |> Map.keys() |> List.last()

        Map.get(last_map, last_key)
        |> Map.merge(WeatherForecastHandler.get_sunrise_and_sunset_information_map(location_name))
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
