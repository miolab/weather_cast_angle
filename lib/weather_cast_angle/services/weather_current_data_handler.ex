defmodule WeatherCastAngle.Services.WeatherCurrentDataHandler do
  @moduledoc """
  Provides functions for handling current weather data HTTP request responses.
  """
  alias WeatherCastAngle.Services.WeatherDataProcessor
  alias WeatherCastAngle.Utils.DatetimeProcessor
  alias WeatherCastAngle.Utils

  @current_weather_url "https://api.openweathermap.org/data/2.5/weather"

  defp _get_current_weather_data(location_name) do
    cache_key = location_name <> "_current_weather"

    WeatherDataProcessor.get_open_weather_data(
      location_name,
      cache_key,
      @current_weather_url
    )
  end

  @doc """
  Extracts and transforms specific current weather data.
  """
  @spec extract_current_weather(String.t()) :: %{
          dt: String.t(),
          weather_description: String.t(),
          weather_main: String.t(),
          weather_icon_uri: String.t(),
          wind_speed: non_neg_integer(),
          wind_deg: String.t(),
          wind_direction_flag: atom(),
          main_temp: integer(),
          main_humidity: integer(),
          sunrise: non_neg_integer(),
          sunset: non_neg_integer()
        }
  def extract_current_weather(location_name) do
    current_weather_response_map = _get_current_weather_data(location_name)

    does_any_key_missing =
      Utils.Collection.does_any_key_missing_in_map(current_weather_response_map, [
        "dt",
        "main",
        "wind",
        "weather",
        "sys"
      ])

    is_map_key_error = is_map_key(current_weather_response_map, "Error")

    cond do
      does_any_key_missing or is_map_key_error ->
        _extract_current_weather_default()

      true ->
        weather_map =
          current_weather_response_map["weather"] |> List.first()

        wind_degree = current_weather_response_map["wind"]["deg"]

        %{
          dt:
            current_weather_response_map["dt"]
            |> DatetimeProcessor.convert_unix_to_datetime_string(),
          weather_description: weather_map |> Map.get("description"),
          weather_main: weather_map |> Map.get("main"),
          weather_icon_uri:
            "https://openweathermap.org/img/wn/#{weather_map |> Map.get("icon")}@2x.png",
          wind_speed:
            current_weather_response_map["wind"]["speed"]
            |> WeatherDataProcessor.round_wind_speed(),
          wind_deg: wind_degree |> WeatherDataProcessor.wind_direction(),
          wind_direction_flag: wind_degree |> WeatherDataProcessor.wind_direction_flag(),
          main_temp:
            current_weather_response_map["main"]["temp"]
            |> WeatherDataProcessor.kelvin_to_celsius_temperature(),
          main_humidity: current_weather_response_map["main"]["humidity"],
          sunrise:
            current_weather_response_map["sys"]["sunrise"]
            |> DatetimeProcessor.convert_unix_to_hour_minute_format(),
          sunset:
            current_weather_response_map["sys"]["sunset"]
            |> DatetimeProcessor.convert_unix_to_hour_minute_format()
        }
    end
  end

  @doc """
  Parse and get current date and hour from `yyyy-mm-dd HH` formatted string.
  """
  @spec current_date_and_hour(String.t()) :: %{date: String.t(), hour: String.t()}
  def current_date_and_hour(location_name) do
    case extract_current_weather(location_name).dt |> String.split(" ") do
      [date, hour] -> %{date: date, hour: hour}
      _ -> %{date: "9999-99-99", hour: "99"}
    end
  end

  defp _extract_current_weather_default() do
    %{
      dt: "",
      weather_description: "",
      weather_main: "",
      weather_icon_uri: "",
      wind_speed: 0,
      wind_deg: "",
      wind_direction_flag: nil,
      main_temp: 0,
      main_humidity: 0,
      sunrise: 0,
      sunset: 0
    }
  end
end
