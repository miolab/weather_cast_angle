defmodule WeatherCastAngle.Utils.Locations.GetLocationMapByNameTest do
  use ExUnit.Case

  test "Get location map by selected location name." do
    actual = WeatherCastAngle.Utils.Locations.get_location_map_by_name("tokyo")

    assert actual == %{
             tide_location_code: "TK",
             latitude: 35.689499,
             longitude: 139.691711
           }
  end

  test "If NON-existent location name selected, a default undefined map is returned." do
    actual = WeatherCastAngle.Utils.Locations.get_location_map_by_name("undefined_location")

    assert actual == %{
             tide_location_code: "",
             latitude: 0.0,
             longitude: 0.0
           }
  end
end
