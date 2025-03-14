defmodule WeatherCastAngleWeb.PageController do
  use WeatherCastAngleWeb, :controller

  alias WeatherCastAngleWeb.SvgIcons
  alias WeatherCastAngle.Utils
  alias WeatherCastAngle.Utils.DatetimeProcessor
  alias WeatherCastAngle.Services.TideDataHandler
  alias WeatherCastAngle.Services.WeatherCurrentDataHandler
  alias WeatherCastAngle.Services.WeatherForecastHandler
  alias WeatherCastAngle.Services.SeaWaterTemperatureHandler
  alias WeatherCastAngle.Services.ForecastAggregator

  @location_names Utils.Locations.location_names()

  def home(conn, _params) do
    current_date = DatetimeProcessor.get_current_date_string()
    location_name = Utils.Locations.default_location_name()

    default_tide_location_code = Utils.Locations.default_tide_location_code()
    tide_response_map = _fetch_tide_response_map(current_date, default_tide_location_code)

    forecast_map = _forecast_map(location_name, current_date)

    render(
      conn,
      :home,
      tide_response: tide_response_map[current_date],
      current_weather_map: _current_weather_map(location_name),
      current_hour: _current_hour(location_name),
      weather_forecast_map: _weather_forecast_map(location_name, current_date),
      selected_location: location_name,
      location_names: @location_names,
      weather_description: forecast_map |> Map.get(:weather_description),
      weather_icon_uri: forecast_map |> Map.get(:weather_icon_uri),
      wind_deg: forecast_map |> Map.get(:wind_deg),
      wind_speed: forecast_map |> Map.get(:wind_speed),
      main_temp: forecast_map |> Map.get(:main_temp),
      main_humidity: forecast_map |> Map.get(:main_humidity),
      moon_age: forecast_map |> Map.get(:moon_age),
      moon_phase: forecast_map |> Map.get(:moon_phase),
      tide_name: forecast_map |> Map.get(:tide_name),
      sunrise: forecast_map |> Map.get(:sunrise),
      sunset: forecast_map |> Map.get(:sunset),
      previous_days_sea_temperatures: _previous_days_sea_temperatures(location_name),
      recent_forecasts: _recent_forecasts(location_name),
      sunrise_icon: SvgIcons.sunrise_icon(%{}),
      sunset_icon: SvgIcons.sunset_icon(%{}),
      humidity_icon: SvgIcons.humidity_icon(%{}),
      wind_speed_icon: SvgIcons.wind_speed_icon(%{}),
      wind_direction_icon: SvgIcons.wind_direction_icon(%{direction: ""}),
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
      cond do
        Utils.Validation.validate_lowercase_alphabetic_length(location_name, 2, 12) == :ok and
            Utils.Validation.validate_in_array(location_name, Utils.Locations.location_names()) ==
              :ok ->
          location_name

        true ->
          Utils.Locations.default_location_name()
      end

    tide_location_code = Utils.Locations.get_location_code_by_name(target_location_name)
    tide_response_map = _fetch_tide_response_map(target_date, tide_location_code)

    forecast_map = _forecast_map(target_location_name, target_date)

    render(
      conn,
      :home,
      tide_response: tide_response_map[target_date],
      current_weather_map: _current_weather_map(target_location_name),
      current_hour: _current_hour(target_location_name),
      weather_forecast_map: _weather_forecast_map(target_location_name, target_date),
      selected_location: target_location_name,
      location_names: @location_names,
      weather_description: forecast_map |> Map.get(:weather_description),
      weather_icon_uri: forecast_map |> Map.get(:weather_icon_uri),
      wind_deg: forecast_map |> Map.get(:wind_deg),
      wind_speed: forecast_map |> Map.get(:wind_speed),
      main_temp: forecast_map |> Map.get(:main_temp),
      main_humidity: forecast_map |> Map.get(:main_humidity),
      moon_age: forecast_map |> Map.get(:moon_age),
      moon_phase: forecast_map |> Map.get(:moon_phase),
      tide_name: forecast_map |> Map.get(:tide_name),
      sunrise: forecast_map |> Map.get(:sunrise),
      sunset: forecast_map |> Map.get(:sunset),
      previous_days_sea_temperatures: _previous_days_sea_temperatures(target_location_name),
      recent_forecasts: _recent_forecasts(location_name),
      sunrise_icon: SvgIcons.sunrise_icon(%{}),
      sunset_icon: SvgIcons.sunset_icon(%{}),
      humidity_icon: SvgIcons.humidity_icon(%{}),
      wind_speed_icon: SvgIcons.wind_speed_icon(%{}),
      wind_direction_icon: SvgIcons.wind_direction_icon(%{direction: ""}),
      layout: false
    )
  end

  defp _forecast_map(location_name, date),
    do: ForecastAggregator.get_forecast_by_date(location_name, date)

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

  defp _recent_forecasts(location_name),
    do: ForecastAggregator.get_recent_forecasts(location_name)

  defp _previous_days_sea_temperatures(location_name),
    do: SeaWaterTemperatureHandler.get_previous_days_temperatures(location_name)
end
