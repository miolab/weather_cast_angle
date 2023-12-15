defmodule WeatherCastAngleWeb.PageController do
  use WeatherCastAngleWeb, :controller

  def home(conn, _params) do
    current_date = WeatherCastAngle.Services.DaytimeProcessor.get_current_date_string()

    response_map = fetch_response_map(current_date, "MO")

    render(
      conn,
      :home,
      response: response_map[current_date],
      layout: false
    )
  end

  def tide_data(conn, %{"input_date" => input_date}) do
    response_map = fetch_response_map(input_date, "MO")

    render(
      conn,
      :home,
      response: response_map[input_date],
      layout: false
    )
  end

  defp fetch_response_map(date_string, location_code) do
    [year | _] = String.split(date_string, "-")

    WeatherCastAngle.Services.ResponseProcessor.get_response_body(
      String.to_integer(year),
      location_code
    )
  end
end
