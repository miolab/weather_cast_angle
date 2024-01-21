defmodule WeatherCastAngle.Services.SeaWaterTemperatureHandler do
  # TODO: 各areaコードをlocationに追加する
  @sea_area_code 602

  def get_previous_days_temperatures() do
    url =
      "https://www.data.jma.go.jp/kaiyou/data/db/kaikyo/series/engan/txt/area#{@sea_area_code}.txt"

    res = HTTPoison.get(url)

    case res do
      {:ok, %HTTPoison.Response{body: response_body}} ->
        result =
          response_body

        result

      {:error, %HTTPoison.Error{reason: reason}} ->
        %{"Error" => reason}
    end
  end
end
