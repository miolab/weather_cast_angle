defmodule WeatherCastAngle.Services.WeatherForecastHandler do
  @moduledoc """
  Provides functions for handling weather forecast HTTP request responses.
  """
  alias WeatherCastAngle.Services.WeatherDataProcessor
  alias WeatherCastAngle.Services.DatetimeProcessor

  @forecast_url "https://api.openweathermap.org/data/2.5/forecast"

  # TODO: fix to private
  def get_weather_forecast(location_name) do
    cache_key = location_name <> "_weather_forecast"

    WeatherDataProcessor.get_open_weather_data(
      location_name,
      cache_key,
      @forecast_url
    )
  end

  @doc """
  Extracts and transforms specific weather forecast.
  """
  @spec extract_weather_forecast(String.t()) ::
          [
            {
              String.t(),
              %{
                dt: String.t(),
                weather_description: String.t(),
                weather_main: String.t(),
                weather_icon_uri: String.t(),
                probability_of_precipitation: non_neg_integer(),
                wind_speed: float(),
                wind_deg: non_neg_integer(),
                main_temp: float(),
                main_humidity: integer()
              }
            }
          ]
          | []
  def extract_weather_forecast(location_name) do
    forecast_maps = get_weather_forecast(location_name)["list"]

    cond do
      is_nil(forecast_maps) ->
        []

      true ->
        forecast_maps
        |> Enum.map(fn forecast_map ->
          weather_map = Enum.at(forecast_map["weather"], 0, %{})

          {
            forecast_map["dt"]
            |> DatetimeProcessor.convert_unix_to_datetime_string(),
            %{
              weather_description: weather_map |> Map.get("description", ""),
              weather_main: weather_map |> Map.get("main", ""),
              weather_icon_uri:
                "https://openweathermap.org/img/wn/#{weather_map |> Map.get("icon")}@2x.png",
              probability_of_precipitation:
                forecast_map["pop"]
                |> WeatherDataProcessor.convert_to_percentage(),
              wind_speed:
                forecast_map["wind"]["speed"]
                |> WeatherDataProcessor.round_wind_speed(),
              wind_deg: forecast_map["wind"]["deg"],
              main_temp:
                forecast_map["main"]["temp"]
                |> WeatherDataProcessor.kelvin_to_celsius_temperature(),
              main_humidity: forecast_map["main"]["humidity"]
            }
          }
        end)
    end
  end

  @doc """
  Fetches the weather forecast data for a specific location and date, and returns it as a list of maps.

  - Each map in the list represents the weather forecast for a specific time of the day, with the time as the key and the forecast data as the value.
  - The returned list is a map and does not guarantee the order of times. If the order is important, the calling side (e.g., TypeScript) should sort the data based on the time keys as needed.
  """
  @spec get_forecast_map_by_date(String.t(), String.t()) ::
          [
            %{
              String.t() => %{
                weather_description: String.t(),
                weather_main: String.t(),
                weather_icon_uri: String.t(),
                probability_of_precipitation: non_neg_integer(),
                wind_speed: float(),
                wind_deg: non_neg_integer(),
                main_temp: float(),
                main_humidity: integer()
              }
            }
          ]
          | []
  def get_forecast_map_by_date(location_name, date) do
    forecast = extract_weather_forecast(location_name)

    cond do
      forecast == [] ->
        []

      true ->
        forecast
        |> Enum.filter(fn {datetime, _} -> String.starts_with?(datetime, date) end)
        |> Enum.map(fn {datetime, value_map} ->
          date_and_time = String.split(datetime, " ")
          time = List.last(date_and_time)

          %{time => value_map}
        end)
    end
  end
end
