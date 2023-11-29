defmodule WeatherCastAngleWeb.PageController do
  use WeatherCastAngleWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    res =
      HTTPoison.get("https://www.data.jma.go.jp/gmd/kaiyou/data/db/tide/suisan/txt/2023/MO.txt")

    response_text =
      case res do
        {:ok, %HTTPoison.Response{body: response_body}} ->
          response_body

        {:error, %HTTPoison.Error{reason: reason}} ->
          # TODO: エラー時にどう振る舞うかをちゃんと書く
          "Error: " <> to_string(reason)
      end

    render(
      conn,
      :home,
      response: response_text,
      layout: false
    )
  end
end
