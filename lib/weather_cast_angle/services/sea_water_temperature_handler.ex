defmodule WeatherCastAngle.Services.SeaWaterTemperatureHandler do
  @spec get_previous_days_temperatures(String.t()) :: [{String.t(), float()}]
  def get_previous_days_temperatures(location_name) do
    cache_key = "#{location_name}_previous_days_temperatures"

    sea_area_code = _get_sea_area_code(location_name)

    _get_previous_days_temperatures_data(sea_area_code, cache_key)
    |> WeatherCastAngle.Services.SeaWaterTemperatureProcessor.convert_to_sorted_keyword_list()
  end

  defp _get_sea_area_code(location_name) do
    location_name
    |> WeatherCastAngle.Utils.Locations.get_location_map_by_name()
    |> Map.get(:sea_area_code)
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
              |> WeatherCastAngle.Services.SeaWaterTemperatureProcessor.previous_days_records()

            WeatherCastAngle.Cache.put_cache(cache_key, result |> Jason.encode!(), 60)

            result

          {:error, %HTTPoison.Error{reason: reason}} ->
            %{"Error" => reason}
        end

      _ ->
        cached_value
        |> Jason.decode!()
    end
  end
end
