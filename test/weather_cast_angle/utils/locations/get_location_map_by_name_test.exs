defmodule WeatherCastAngle.Utils.Locations.GetLocationMapByNameTest do
  use ExUnit.Case

  test "Get location map by selected location name." do
    actual = WeatherCastAngle.Utils.Locations.get_location_map_by_name("tokyo")

    assert actual == %{
             place_name: "東京",
             tide_location_code: "TK",
             sea_area_code: 306,
             latitude: 35.689499,
             longitude: 139.691711
           }
  end

  test "If NON-existent location name selected, a default undefined map is returned." do
    actual = WeatherCastAngle.Utils.Locations.get_location_map_by_name("undefined_location")

    assert actual == %{
             place_name: "",
             tide_location_code: "",
             sea_area_code: 0,
             latitude: 0.0,
             longitude: 0.0
           }
  end
end
