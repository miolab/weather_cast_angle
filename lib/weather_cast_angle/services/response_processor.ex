defmodule WeatherCastAngle.Services.ResponseProcessor do
  @target_url "https://www.data.jma.go.jp/gmd/kaiyou/data/db/tide/suisan/txt/"

  @spec get_response_body(pos_integer, String.t()) :: String.t()
  def get_response_body(year, location_code) do
    res =
      (@target_url <> "#{year}/#{location_code}.txt")
      |> HTTPoison.get()

    case res do
      {:ok, %HTTPoison.Response{body: response_body}} ->
        response_body

      {:error, %HTTPoison.Error{reason: reason}} ->
        # TODO: エラー時にどう振る舞うかをちゃんと書く
        "Error: " <> to_string(reason)
    end
  end
end
