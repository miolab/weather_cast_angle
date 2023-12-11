defmodule WeatherCastAngleWeb.PageController do
  use WeatherCastAngleWeb, :controller

  def home(conn, _params) do
    response_map = WeatherCastAngle.Services.ResponseProcessor.get_response_body(2023, "MO")

    # WIP: sample
    target_date = "2023-08-23"

    render(
      conn,
      :home,
      response: response_map[target_date],
      layout: false
    )
  end
end
