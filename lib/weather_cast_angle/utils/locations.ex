defmodule WeatherCastAngle.Utils.Locations do
  @doc """
  Keyword list consisting of location name and location data map.
  """
  @spec location_array() :: [
          {
            String.t(),
            %{
              place_name: String.t(),
              tide_location_code: String.t(),
              sea_area_code: non_neg_integer(),
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
          place_name: "門司",
          tide_location_code: "MO",
          sea_area_code: 602,
          latitude: 33.9484466691993,
          longitude: 130.96263530779785
        }
      },
      {
        "hagi",
        %{
          place_name: "萩",
          tide_location_code: "K5",
          sea_area_code: 601,
          # Senzaki
          latitude: 34.383331,
          longitude: 131.199997
        }
      },
      {
        "tokyo",
        %{
          place_name: "東京",
          tide_location_code: "TK",
          sea_area_code: 306,
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
  Return location map by input location name.
  """
  @spec get_location_map_by_name(String.t()) :: %{
          place_name: String.t(),
          tide_location_code: String.t(),
          sea_area_code: non_neg_integer(),
          latitude: float(),
          longitude: float()
        }
  def get_location_map_by_name(location_name) do
    location_array()
    |> Enum.find(
      undefined_location_keyword_list(),
      fn {key, _} -> key == location_name end
    )
    |> elem(1)
  end

  @doc """
  Get place name like '東京' or '門司' by location name.
  """
  @spec get_place_name_by_location_name(String.t()) :: String.t()
  def get_place_name_by_location_name(location_name) do
    get_location_map_by_name(location_name) |> Map.get(:place_name)
  end

  @doc """
  Get location code by location name.
  """
  @spec get_location_code_by_name(String.t()) :: String.t()
  def get_location_code_by_name(location_name) do
    get_location_map_by_name(location_name)
    |> Map.get(:tide_location_code)
  end

  defp undefined_location_keyword_list() do
    {
      "",
      %{
        place_name: "",
        tide_location_code: "",
        sea_area_code: 0,
        latitude: 0.0,
        longitude: 0.0
      }
    }
  end
end
