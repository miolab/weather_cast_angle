defmodule WeatherCastAngleWeb.PageController do
  use WeatherCastAngleWeb, :controller

  def home(conn, _params) do
    # TODO: show today as default using timex
    target_date = "2023-08-23"

    response_map = fetch_response_map(target_date, "MO")

    render(
      conn,
      :home,
      response: response_map[target_date],
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
