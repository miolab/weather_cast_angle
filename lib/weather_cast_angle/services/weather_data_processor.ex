defmodule WeatherCastAngle.Services.WeatherDataProcessor do
  @open_weather_api_key System.get_env("OPEN_WEATHER_API_KEY")

  @spec get_open_weather_data(String.t(), String.t(), String.t()) :: map()
  def get_open_weather_data(location_name, cache_key, target_url) do
    # TODO: location_name が location_names に含まれるか保証するため assertion 入れる。含まれなかったら default_name の情報を返して、default のレンダリングをするのでよい。リダイレクトする方針も検討

    cached_value = WeatherCastAngle.Cache.get_cache(cache_key)

    case cached_value do
      nil ->
        res =
          HTTPoison.get(target_url, [],
            params: _query_parameters_for_get_weather_data(location_name)
          )

        case res do
          {:ok, %HTTPoison.Response{body: response_body}} ->
            WeatherCastAngle.Cache.put_cache(cache_key, response_body, 5)

            response_body |> Jason.decode!()

          {:error, %HTTPoison.Error{reason: reason}} ->
            %{"Error" => reason}
        end

      _ ->
        cached_value |> Jason.decode!()
    end
  end

  defp _query_parameters_for_get_weather_data(location_name) do
    location_map = WeatherCastAngle.Utils.Locations.get_location_map_by_name(location_name)

    %{
      lat: location_map |> Map.get(:latitude) |> Float.to_string(),
      lon: location_map |> Map.get(:longitude) |> Float.to_string(),
      lang: "ja",
      APPID: @open_weather_api_key
    }
  end

  @doc """
  Converts a temperature from Kelvin to Celsius.
  """
  @spec kelvin_to_celsius_temperature(float()) :: float()
  def kelvin_to_celsius_temperature(kelvin), do: (kelvin - 273.15) |> Float.round(1)

  @doc """
  Converts a float value to a percentage.
  This function is intended for use in the calculation of precipitation probability.
  """
  @spec convert_to_percentage(float | 0 | 1) :: non_neg_integer()
  def convert_to_percentage(probability) do
    cond do
      is_integer(probability) or
          Float.floor(probability, 1) == probability ->
        probability * 100

      true ->
        probability
        |> Float.round(1)
        |> Kernel.*(100)
        |> trunc()
    end
  end
end
