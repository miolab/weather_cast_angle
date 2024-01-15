defmodule WeatherCastAngle.Services.TideDataHandler do
  @target_url "https://www.data.jma.go.jp/gmd/kaiyou/data/db/tide/suisan/txt/"

  def get_tide_data(year, location_code) do
    cache_key = "#{year}_#{location_code}_tide"

    WeatherCastAngle.Services.TideDataHandler.get_response_body(year, location_code, cache_key)
  end

  # TODO: fix to private
  @doc """
  HTTP GET request and and return response body.
  """
  @spec get_response_body(pos_integer, String.t(), String.t()) ::
          %{
            String.t() => %{
              String.t() => [integer()],
              String.t() => String.t(),
              String.t() => String.t(),
              String.t() => [%{String.t() => integer()}],
              String.t() => [%{String.t() => integer()}]
            }
          }
          | %{String.t() => String.t()}
  def get_response_body(year, location_code, cache_key) do
    cached_value = WeatherCastAngle.Cache.get_cache(cache_key)

    case cached_value do
      nil ->
        res = HTTPoison.get(@target_url <> "#{year}/#{location_code}.txt")

        case res do
          {:ok, %HTTPoison.Response{body: response_body}} ->
            result =
              response_body
              |> parsed_lines_array()
              |> Enum.map(&parse_tide_data/1)
              |> Enum.reduce(%{}, &Map.put(&2, &1 |> Map.get("target_date"), &1))

            WeatherCastAngle.Cache.put_cache(cache_key, result |> Jason.encode!(), 1)
            result

          {:error, %HTTPoison.Error{reason: reason}} ->
            %{"Error" => reason}
        end

      _ ->
        cached_value |> Jason.decode!()
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
          String.t() => [integer()],
          String.t() => String.t(),
          String.t() => String.t(),
          String.t() => [%{String.t() => integer()}],
          String.t() => [%{String.t() => integer()}]
        }
  def parse_tide_data(string) do
    hourly_tide_levels = String.slice(string, 0, 72) |> _parse_hourly_tide_levels()

    date =
      String.slice(string, 72, 6)
      |> WeatherCastAngle.Services.DatetimeProcessor.convert_date_format()

    location_code = String.slice(string, 78, 2)
    high_tide = String.slice(string, 80, 28) |> _parse_tide_times_and_levels()
    low_tide = String.slice(string, 108, 28) |> _parse_tide_times_and_levels()

    %{
      "hourly_tide_levels" => hourly_tide_levels,
      "target_date" => date,
      "location_code" => location_code,
      "high_tide" => high_tide,
      "low_tide" => low_tide
    }
  end

  defp _parse_hourly_tide_levels(string_sliced) do
    # Parse hourly tide levels.
    string_sliced
    |> String.graphemes()
    |> Enum.chunk_every(3)
    |> Enum.map(&(&1 |> Enum.join() |> String.trim() |> String.to_integer()))
  end

  defp _parse_tide_times_and_levels(string_sliced) do
    # Parse string to high and low tide times and tide levels.
    string_sliced
    |> String.graphemes()
    |> Enum.chunk_every(7)
    |> Enum.map(fn chunk ->
      {
        time =
          (Enum.slice(chunk, 0, 2) ++ [":"] ++ Enum.slice(chunk, 2, 2))
          |> Enum.join("")
          |> String.replace(" ", "0"),
        level = Enum.slice(chunk, 4, 3) |> Enum.join("") |> String.trim() |> String.to_integer()
      }

      %{time => level}
    end)
  end
end
