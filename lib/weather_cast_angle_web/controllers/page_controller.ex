defmodule WeatherCastAngleWeb.PageController do
  use WeatherCastAngleWeb, :controller

  alias WeatherCastAngle.Utils
  alias WeatherCastAngle.Services.DatetimeProcessor
  alias WeatherCastAngle.Services.TideDataHandler
  alias WeatherCastAngle.Services.WeatherCurrentDataHandler
  alias WeatherCastAngle.Services.WeatherForecastHandler
  alias WeatherCastAngle.Services.MoonStatusCalculator
  alias WeatherCastAngle.Services.SeaWaterTemperatureHandler

  @location_names Utils.Locations.location_names()

  def home(conn, _params) do
    current_date = DatetimeProcessor.get_current_date_string()
    location_name = Utils.Locations.default_location_name()

    default_tide_location_code = Utils.Locations.default_tide_location_code()
    tide_response_map = _fetch_tide_response_map(current_date, default_tide_location_code)

    render(
      conn,
      :home,
      tide_response: tide_response_map[current_date],
      current_weather_map: _current_weather_map(location_name),
      current_hour: _current_hour(location_name),
      weather_forecast_map: _weather_forecast_map(location_name, current_date),
      selected_location: location_name,
      location_names: @location_names,
      moon_age: _fetch_moon_status(current_date, location_name) |> Map.get("moon_age"),
      moon_phase: _fetch_moon_status(current_date, location_name) |> Map.get("moon_phase"),
      previous_days_sea_temperatures: _previous_days_sea_temperatures(location_name),
      # TODO: あとで消す
      current_weather_response: _fetch_current_weather_response_map(location_name),
      # TODO: あとで消す
      weather_forecast_response: _fetch_weather_forecast_response_map(location_name),
      layout: false
    )
  end

  def tide_data(conn, %{
        "input_date" => input_date,
        "location_name" => location_name
      }) do
    # TODO: input valuesがinvalidだったらフォールバックさせてお茶を濁しているが今後エラー画面を生やしてリダイレクトしたい
    target_date =
      case Utils.Validation.validate_date_format(input_date) do
        :ok -> input_date
        _ -> DatetimeProcessor.get_current_date_string()
      end

    target_location_name =
      case Utils.Validation.validate_lowercase_alphabetic_length(location_name, 2, 12) do
        :ok -> location_name
        _ -> Utils.Locations.default_location_name()
      end

    tide_location_code = Utils.Locations.get_location_code_by_name(target_location_name)
    tide_response_map = _fetch_tide_response_map(target_date, tide_location_code)

    render(
      conn,
      :home,
      tide_response: tide_response_map[target_date],
      current_weather_map: _current_weather_map(target_location_name),
      current_hour: _current_hour(target_location_name),
      weather_forecast_map: _weather_forecast_map(target_location_name, target_date),
      selected_location: target_location_name,
      location_names: @location_names,
      moon_age: _fetch_moon_status(target_date, target_location_name) |> Map.get("moon_age"),
      moon_phase: _fetch_moon_status(target_date, target_location_name) |> Map.get("moon_phase"),
      previous_days_sea_temperatures: _previous_days_sea_temperatures(target_location_name),
      # TODO: あとで消す
      current_weather_response: _fetch_current_weather_response_map(target_location_name),
      # TODO: あとで消す
      weather_forecast_response: _fetch_weather_forecast_response_map(target_location_name),
      layout: false
    )
  end

  defp _fetch_tide_response_map(date_string, location_code) do
    [year | _] = String.split(date_string, "-")

    TideDataHandler.get_tide_data(
      String.to_integer(year),
      location_code
    )
  end

  defp _current_weather_map(location_name),
    do: WeatherCurrentDataHandler.extract_current_weather(location_name)

  defp _current_hour(location_name),
    do: WeatherCurrentDataHandler.current_date_and_hour(location_name).hour

  defp _weather_forecast_map(location_name, date),
    do: WeatherForecastHandler.get_forecast_map_by_date(location_name, date)

  # TODO: あとで消す
  defp _fetch_current_weather_response_map(location_name),
    do: WeatherCurrentDataHandler.get_current_weather_data(location_name)

  # TODO: あとで消す
  defp _fetch_weather_forecast_response_map(location_name),
    do: WeatherForecastHandler.get_weather_forecast(location_name)

  defp _fetch_moon_status(date, location_name) do
    location_map = Utils.Locations.get_location_map_by_name(location_name)

    latitude = location_map |> Map.get(:latitude)
    longitude = location_map |> Map.get(:longitude)

    %{
      "moon_age" => MoonStatusCalculator.get_moon_age(date, latitude, longitude),
      "moon_phase" => MoonStatusCalculator.get_moon_phase(date, latitude, longitude)
    }
  end

  defp _previous_days_sea_temperatures(location_name),
    do: SeaWaterTemperatureHandler.get_previous_days_temperatures(location_name)
end
