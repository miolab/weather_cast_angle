defmodule WeatherCastAngle.Services.WeatherCurrentDataHandler do
  @moduledoc """
  Provides functions for handling current weather data HTTP request responses.
  """
  alias WeatherCastAngle.Services.WeatherDataProcessor
  alias WeatherCastAngle.Services.DatetimeProcessor

  @current_weather_url "https://api.openweathermap.org/data/2.5/weather"

  # TODO: fix to private
  def get_current_weather_data(location_name) do
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
          main_temp: integer(),
          main_humidity: integer()
        }
  def extract_current_weather(location_name) do
    current_weather_response_map = get_current_weather_data(location_name)

    required_keys = ["dt", "main", "wind", "weather"]

    cond do
      _does_any_key_missing(current_weather_response_map, required_keys) or
          is_map_key(current_weather_response_map, "Error") ->
        _extract_current_weather_default()

      true ->
        weather_map =
          current_weather_response_map["weather"] |> List.first()

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
          wind_deg:
            current_weather_response_map["wind"]["deg"]
            |> WeatherDataProcessor.wind_direction(),
          main_temp:
            current_weather_response_map["main"]["temp"]
            |> WeatherDataProcessor.kelvin_to_celsius_temperature(),
          main_humidity: current_weather_response_map["main"]["humidity"]
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
      main_temp: 0,
      main_humidity: 0
    }
  end

  defp _does_any_key_missing(map, keys) do
    Enum.any?(keys, fn key -> !Map.has_key?(map, key) end)
  end
end
