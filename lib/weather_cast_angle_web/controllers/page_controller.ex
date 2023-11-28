defmodule WeatherCastAngleWeb.PageController do
  use WeatherCastAngleWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    # TODO: WIP
    response = "-- Sample responses --"

    render(
      conn,
      :home,
      response: response,
      layout: false
    )
  end
end
