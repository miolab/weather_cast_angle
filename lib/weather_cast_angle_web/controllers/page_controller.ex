defmodule WeatherCastAngleWeb.PageController do
  use WeatherCastAngleWeb, :controller

  @location_names WeatherCastAngle.Utils.Locations.location_names()

  def home(conn, _params) do
    location_name = WeatherCastAngle.Utils.Locations.default_location_name()

    current_date = WeatherCastAngle.Services.DatetimeProcessor.get_current_date_string()
    default_tide_location_code = WeatherCastAngle.Utils.Locations.default_tide_location_code()

    tide_response_map = fetch_tide_response_map(current_date, default_tide_location_code)

    # TODO: あとで消す
    current_weather_response_map = fetch_current_weather_response_map(location_name)

    render(
      conn,
      :home,
      tide_response: tide_response_map[current_date],
      current_weather_response: current_weather_response_map,
      current_weather_map: _current_weather_map(location_name),
      selected_location: location_name,
      location_names: @location_names,
      layout: false
    )
  end

  def tide_data(conn, %{
        "input_date" => input_date,
        "location_name" => location_name
      }) do
    tide_location_code = WeatherCastAngle.Utils.Locations.get_location_code_by_name(location_name)
    tide_response_map = fetch_tide_response_map(input_date, tide_location_code)

    # TODO: あとで消す
    current_weather_response_map = fetch_current_weather_response_map(location_name)

    render(
      conn,
      :home,
      tide_response: tide_response_map[input_date],
      current_weather_response: current_weather_response_map,
      current_weather_map: _current_weather_map(location_name),
      selected_location: location_name,
      location_names: @location_names,
      layout: false
    )
  end

  defp fetch_tide_response_map(date_string, location_code) do
    [year | _] = String.split(date_string, "-")

    WeatherCastAngle.Services.TideDataHandler.get_response_body(
      String.to_integer(year),
      location_code
    )
  end

  defp _current_weather_map(location_name) do
    WeatherCastAngle.Services.WeatherCurrentDataHandler.extract_current_weather(location_name)
  end

  # TODO: あとで消す
  defp fetch_current_weather_response_map(location_name) do
    WeatherCastAngle.Services.WeatherCurrentDataHandler.get_current_weather_data(location_name)
  end
end
