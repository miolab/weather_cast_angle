defmodule WeatherCastAngle.Services.WeatherDataHandler do
  def get_current_weather_data(location_name) do
    current_weather_url = "https://api.openweathermap.org/data/2.5/weather"

    # TODO: location_name が location_names に含まれるか保証するため assertion 入れる。含まれなかったら default_name の情報を返して、default のレンダリングをするのでよい。リダイレクトする方針も検討
    location_map = WeatherCastAngle.Utils.Locations.get_location_map_by_name(location_name)

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
        response_body
        |> Jason.decode!()

      {:error, %HTTPoison.Error{reason: reason}} ->
        %{"Error" => reason}
    end
  end

  @doc """
  Extracts and transforms specific weather data from a given map.
  """
  @spec extract_current_weather(map()) :: %{
          weather_description: String.t(),
          weather_main: String.t(),
          wind_speed: float(),
          main_temp: float(),
          main_humidity: integer()
        }
  def extract_current_weather(current_weather_response_map) do
    weather_map = current_weather_response_map["weather"] |> List.first()

    %{
      weather_description: weather_map |> Map.get("description"),
      weather_main: weather_map |> Map.get("main"),
      wind_speed: current_weather_response_map["wind"]["speed"],
      main_temp: current_weather_response_map["main"]["temp"] |> kelvin_to_celsius_temperature(),
      main_humidity: current_weather_response_map["main"]["humidity"]
    }
  end

  @doc """
  Converts a temperature from Kelvin to Celsius.
  """
  @spec kelvin_to_celsius_temperature(float()) :: float()
  def kelvin_to_celsius_temperature(kelvin), do: (kelvin - 273.15) |> Float.round(1)

  defp open_weather_api_key(), do: System.get_env("OPEN_WEATHER_API_KEY")
end
