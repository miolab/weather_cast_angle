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

  @spec parsed_lines_array(String.t()) :: [String.t()]
  @doc """
  Splits a given string into an array of strings, each representing a line.

  This function takes a single string as input and divides it at each newline character.
  The result is an array of strings, where each element corresponds to a line from the input string.
  """
  def parsed_lines_array(text) do
    # TODO: カラ文字の扱い あとで検討
    text |> String.split("\n", trim: true)
  end

  @spec parse_date(String.t()) :: String.t()
  @doc """
  Convert date string "YYMMDD" to "YYYY-MM-DD" format.
  """
  def parse_date(date_string) do
    # TODO: 6桁数値文字列のバリデーション追加する
    date_string = String.replace(date_string, " ", "0")

    year =
      String.slice(date_string, 0, 2)
      |> String.to_integer()
      |> Kernel.+(2000)

    month = String.slice(date_string, 2, 2)
    day = String.slice(date_string, 4, 2)

    "#{year}-#{month}-#{day}"
  end
end
