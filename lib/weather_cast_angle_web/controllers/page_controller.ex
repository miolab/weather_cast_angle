defmodule WeatherCastAngleWeb.PageController do
  use WeatherCastAngleWeb, :controller

  def home(conn, _params) do
    response_text = WeatherCastAngle.Services.ResponseProcessor.get_response_body(2023, "MO")

    render(
      conn,
      :home,
      response: response_text,
      layout: false
    )
  end
end
