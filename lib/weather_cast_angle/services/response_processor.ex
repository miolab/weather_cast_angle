defmodule WeatherCastAngle.Services.ResponseProcessor do
  @target_url "https://www.data.jma.go.jp/gmd/kaiyou/data/db/tide/suisan/txt/"

  @doc """
  HTTP GET request and and return response body.
  """
  @spec get_response_body(pos_integer, String.t()) :: %{
          String.t() => %{
            hourly_tide_levels: [integer()],
            target_date: String.t(),
            location_code: String.t(),
            high_tide: [{String.t(), integer()}],
            low_tide: [{String.t(), integer()}]
          }
        }
  def get_response_body(year, location_code) do
    url = @target_url <> "#{year}/#{location_code}.txt"
    res = HTTPoison.get(url)

    case res do
      {:ok, %HTTPoison.Response{body: response_body}} ->
        response_body
        |> parsed_lines_array()
        |> Enum.map(&parse_tide_data/1)
        |> Enum.reduce(%{}, &Map.put(&2, &1.target_date, &1))

      {:error, %HTTPoison.Error{reason: reason}} ->
        # TODO: エラー時にどう振る舞うかをちゃんと書く
        ["Error: " <> to_string(reason)]
    end
  end

  @doc """
  Splits a given string into an array of strings, each representing a line.

  This function takes a single string as input and divides it at each newline character.
  The result is an array of strings, where each element corresponds to a line from the input string.
  """
  @spec parsed_lines_array(String.t()) :: [String.t()]
  def parsed_lines_array(text) when text !== "" do
    text |> String.split("\n", trim: true)
  end

  def parsed_lines_array(text) when text === "", do: [""]

  @doc """
  Parses a given string representing tide data and returns a map with detailed tide information.

  The map includes hourly tide levels, date, location code, high tide times and levels, and low tide times and levels.
  """
  @spec parse_tide_data(String.t()) :: %{
          hourly_tide_levels: [integer()],
          target_date: String.t(),
          location_code: String.t(),
          high_tide: [{String.t(), integer()}],
          low_tide: [{String.t(), integer()}]
        }
  def parse_tide_data(string) do
    hourly_tide_levels = String.slice(string, 0, 72) |> parse_hourly_tide_levels()
    date = String.slice(string, 72, 6) |> convert_date_format()
    location_code = String.slice(string, 78, 2)
    high_tide = String.slice(string, 80, 28) |> parse_tide_times_and_levels()
    low_tide = String.slice(string, 108, 28) |> parse_tide_times_and_levels()

    %{
      hourly_tide_levels: hourly_tide_levels,
      target_date: date,
      location_code: location_code,
      high_tide: high_tide,
      low_tide: low_tide
    }
  end

  defp parse_hourly_tide_levels(string_sliced) do
    # Parse hourly tide levels.
    string_sliced
    |> String.graphemes()
    |> Enum.chunk_every(3)
    |> Enum.map(&(&1 |> Enum.join() |> String.trim() |> String.to_integer()))
  end

  defp convert_date_format(date_string) do
    # Convert date string "YYMMDD" to "YYYY-MM-DD" format.
    date_string = String.replace(date_string, " ", "0")

    year =
      String.slice(date_string, 0, 2)
      |> String.to_integer()
      |> Kernel.+(2000)

    month = String.slice(date_string, 2, 2)
    day = String.slice(date_string, 4, 2)

    "#{year}-#{month}-#{day}"
  end

  defp parse_tide_times_and_levels(string_sliced) do
    # Parse string to high and low tide times and tide levels.
    string_sliced
    |> String.graphemes()
    |> Enum.chunk_every(7)
    |> Enum.map(fn chunk ->
      {
        (Enum.slice(chunk, 0, 2) ++ [":"] ++ Enum.slice(chunk, 2, 2))
        |> Enum.join("")
        |> String.replace(" ", "0"),
        Enum.slice(chunk, 4, 3) |> Enum.join("") |> String.trim() |> String.to_integer()
      }
    end)
  end
end
