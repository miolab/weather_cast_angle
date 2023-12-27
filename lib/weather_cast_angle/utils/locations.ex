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
  Location names array.
  """
  @spec location_names :: [String.t()]
  def location_names() do
    location_array()
    |> Enum.map(fn {key, _} -> key end)
  end

  @doc """
  Tide location codes array.
  """
  @spec tide_location_codes :: [String.t()]
  def tide_location_codes() do
    location_array()
    |> Enum.map(fn {_, value} -> value[:tide_location_code] end)
  end

  @doc """
  Return location map by input location name.
  """
  @spec return_selected_location_map(String.t()) :: %{
          tide_location_code: String.t(),
          latitude: float(),
          longitude: float()
        }
  def return_selected_location_map(location_name) do
    location_array()
    |> Enum.find(
      undefined_location_keyword_list(),
      fn {key, _} -> key == location_name end
    )
    |> elem(1)
  end

  @doc """
  Get location code by location name.
  """
  @spec get_location_code_by_name(String.t()) :: String.t()
  def get_location_code_by_name(location_name) do
    return_selected_location_map(location_name)
    |> Map.get(:tide_location_code)
  end

  defp undefined_location_keyword_list() do
    {
      "",
      %{
        tide_location_code: "",
        latitude: 0.0,
        longitude: 0.0
      }
    }
  end
end
