defmodule WeatherCastAngle.Utils.Locations do
  @doc """
  Keyword list consisting of location name and location data map.
  """
  @spec location_array() :: [
          {
            String.t(),
            %{
              tide_location_code: String.t(),
              latitude: float(),
              longitude: float()
            }
          }
        ]
  def location_array() do
    [
      {
        "moji",
        %{
          tide_location_code: "MO",
          latitude: 33.9484466691993,
          longitude: 130.96263530779785
        }
      },
      {
        "hagi",
        %{
          tide_location_code: "K5",
          # Senzaki
          latitude: 34.383331,
          longitude: 131.199997
        }
      },
      {
        "tokyo",
        %{
          tide_location_code: "TK",
          latitude: 35.689499,
          longitude: 139.691711
        }
      }
    ]
  end

  @doc """
  Location name selected when the application first appears.
  """
  @spec default_location_name() :: String.t()
  def default_location_name(), do: location_array() |> hd |> elem(0)

  @doc """
  Location code selected when the application first appears.
  """
  @spec default_tide_location_code() :: String.t()
  def default_tide_location_code() do
    location_array()
    |> hd
    |> elem(1)
    |> Map.get(:tide_location_code)
  end

  @doc """
  Location codes array.
  """
  @spec tide_location_codes :: [String.t()]
  def tide_location_codes() do
    location_array()
    |> Enum.map(fn {_, value} -> value[:tide_location_code] end)
  end
end