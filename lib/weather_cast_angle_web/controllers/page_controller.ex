defmodule WeatherCastAngleWeb.PageController do
  use WeatherCastAngleWeb, :controller

  @tide_location_codes WeatherCastAngle.Utils.Locations.tide_location_codes()

  def home(conn, _params) do
    current_date = WeatherCastAngle.Services.DatetimeProcessor.get_current_date_string()

    default_tide_location_code = WeatherCastAngle.Utils.Locations.default_tide_location_code()
    response_map = fetch_response_map(current_date, default_tide_location_code)

    render(
      conn,
      :home,
      response: response_map[current_date],
      tide_location_codes: @tide_location_codes,
      selected_tide_location_code: default_tide_location_code,
      layout: false
    )
  end

  def tide_data(conn, %{
        "input_date" => input_date,
        "input_location_code" => input_location_code
      }) do
    response_map = fetch_response_map(input_date, input_location_code)

    render(
      conn,
      :home,
      response: response_map[input_date],
      tide_location_codes: @tide_location_codes,
      selected_tide_location_code: input_location_code,
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
