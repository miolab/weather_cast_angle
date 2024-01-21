defmodule WeatherCastAngle.Services.SeaWaterTemperatureHandler do
  # TODO: 各areaコードをlocationに追加する
  # @sea_area_code 602

  def get_previous_days_temperatures(sea_area_code) do
    cache_key = "#{sea_area_code}_area_previous_days_temperatures"

    _get_previous_days_temperatures_data(sea_area_code, cache_key)
  end

  defp _get_previous_days_temperatures_data(sea_area_code, cache_key) do
    cached_value = WeatherCastAngle.Cache.get_cache(cache_key)

    case cached_value do
      nil ->
        url =
          "https://www.data.jma.go.jp/kaiyou/data/db/kaikyo/series/engan/txt/area#{sea_area_code}.txt"

        res = HTTPoison.get(url)

        case res do
          {:ok, %HTTPoison.Response{body: response_body}} ->
            result =
              response_body

            WeatherCastAngle.Cache.put_cache(cache_key, result, 60)

            result

          {:error, %HTTPoison.Error{reason: reason}} ->
            %{"Error" => reason}
        end

      _ ->
        cached_value
    end
  end
end
