defmodule WeatherCastAngleWeb.PageController do
  use WeatherCastAngleWeb, :controller

  @location_code_array ["MO", "K5", "TK"]

  def home(conn, _params) do
    current_date = WeatherCastAngle.Services.DaytimeProcessor.get_current_date_string()

    default_location_code = @location_code_array |> hd
    response_map = fetch_response_map(current_date, default_location_code)

    render(
      conn,
      :home,
      response: response_map[current_date],
      location_code_array: @location_code_array,
      selected_location_code: default_location_code,
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
      location_code_array: @location_code_array,
      selected_location_code: input_location_code,
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
