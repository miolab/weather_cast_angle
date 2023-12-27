defmodule WeatherCastAngleWeb.PageController do
  use WeatherCastAngleWeb, :controller

  @location_names WeatherCastAngle.Utils.Locations.location_names()

  def home(conn, _params) do
    current_date = WeatherCastAngle.Services.DatetimeProcessor.get_current_date_string()
    default_tide_location_code = WeatherCastAngle.Utils.Locations.default_tide_location_code()

    response_map = fetch_response_map(current_date, default_tide_location_code)

    render(
      conn,
      :home,
      response: response_map[current_date],
      selected_location: WeatherCastAngle.Utils.Locations.default_location_name(),
      location_names: @location_names,
      layout: false
    )
  end

  def tide_data(conn, %{
        "input_date" => input_date,
        "location_name" => location_name
      }) do
    tide_location_code = WeatherCastAngle.Utils.Locations.get_location_code_by_name(location_name)
    response_map = fetch_response_map(input_date, tide_location_code)

    render(
      conn,
      :home,
      response: response_map[input_date],
      selected_location: location_name,
      location_names: @location_names,
      layout: false
    )
  end

  defp fetch_response_map(date_string, location_code) do
    [year | _] = String.split(date_string, "-")

    WeatherCastAngle.Services.TideDataHandler.get_response_body(
      String.to_integer(year),
      location_code
    )
  end
end
