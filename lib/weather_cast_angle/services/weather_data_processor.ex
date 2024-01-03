defmodule WeatherCastAngle.Services.WeatherDataProcessor do
  def get_current_weather_data(location_name) do
    current_weather_url = "https://api.openweathermap.org/data/2.5/weather"

    # TODO: location_name が location_names に含まれるか保証するため assertion 入れる。含まれなかったら default_name の情報を返して、default のレンダリングをするのでよい。リダイレクトする方針も検討
    location_map = WeatherCastAngle.Utils.Locations.get_location_map_by_name(location_name)

    cache_key = location_name <> "_current_weather"
    cached_value = WeatherCastAngle.Cache.get_cache(cache_key)

    case cached_value do
      nil ->
        res =
          HTTPoison.get(current_weather_url, [],
            params: %{
              lat: location_map |> Map.get(:latitude) |> Float.to_string(),
              lon: location_map |> Map.get(:longitude) |> Float.to_string(),
              lang: "ja",
              APPID: open_weather_api_key()
            }
          )

        case res do
          {:ok, %HTTPoison.Response{body: response_body}} ->
            WeatherCastAngle.Cache.put_cache(cache_key, response_body)

            response_body |> Jason.decode!()

          {:error, %HTTPoison.Error{reason: reason}} ->
            %{"Error" => reason}
        end

      _ ->
        cached_value |> Jason.decode!()
    end
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
      does_any_key_missing(current_weather_response_map, required_keys) ->
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
            current_weather_response_map["main"]["temp"] |> kelvin_to_celsius_temperature(),
          main_humidity: current_weather_response_map["main"]["humidity"]
        }
    end
  end

  defp does_any_key_missing(map, keys) do
    Enum.any?(keys, fn key -> !Map.has_key?(map, key) end)
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

  @doc """
  Converts a temperature from Kelvin to Celsius.
  """
  @spec kelvin_to_celsius_temperature(float()) :: float()
  def kelvin_to_celsius_temperature(kelvin), do: (kelvin - 273.15) |> Float.round(1)

  defp open_weather_api_key(), do: System.get_env("OPEN_WEATHER_API_KEY")
end
