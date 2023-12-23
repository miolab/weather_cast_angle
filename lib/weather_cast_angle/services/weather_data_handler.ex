defmodule WeatherCastAngle.Services.WeatherDataHandler do
  @target_url "https://api.openweathermap.org/data/2.5/weather"

  def get_response_body() do
    res =
      HTTPoison.get(@target_url, [],
        params: %{
          q: "London,uk",
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
