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
          # exclude: "hourly,daily",
          lang: "ja",
          APPID: open_weather_api_key()
        }
      )

    case res do
      {:ok, %HTTPoison.Response{body: response_body}} ->
        response_body
        |> Jason.decode!()

      {:error, %HTTPoison.Error{reason: reason}} ->
        # TODO: エラー時にどう振る舞うかをちゃんと書く
        ["Error: " <> to_string(reason)]
    end
  end

  defp open_weather_api_key(), do: System.get_env("OPEN_WEATHER_API_KEY")
end
