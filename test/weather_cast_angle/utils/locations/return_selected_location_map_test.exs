defmodule WeatherCastAngle.Utils.Locations.ReturnSelectedLocationMapTest do
  use ExUnit.Case

  test "Return location map by input location." do
    actual = WeatherCastAngle.Utils.Locations.return_selected_location_map("tokyo")

    assert actual == %{
             tide_location_code: "TK",
             latitude: 35.689499,
             longitude: 139.691711
           }
  end

  test "If NON-existent location input, a default undefined map is returned." do
    actual = WeatherCastAngle.Utils.Locations.return_selected_location_map("undefined_location")

    assert actual == %{
             tide_location_code: "",
             latitude: 0.0,
             longitude: 0.0
           }
  end
end
