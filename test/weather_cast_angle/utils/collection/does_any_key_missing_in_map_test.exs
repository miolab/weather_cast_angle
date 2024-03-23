defmodule WeatherCastAngle.Utils.Collection.DoesAnyKeyMissingInMapTest do
  use ExUnit.Case
  alias WeatherCastAngle.Utils

  doctest WeatherCastAngle.Utils.Collection

  describe "Returns whether or not any required key is missing from the map" do
    @target_map %{
      "a" => 1,
      "b" => 2,
      "c" => 3
    }

    test "Returns `true` if it is missing" do
      assert Utils.Collection.does_any_key_missing_in_map(@target_map, ["a", "b", "c", "d"]) ==
               true
    end

    test "Returns `false` if it is included" do
      assert Utils.Collection.does_any_key_missing_in_map(@target_map, ["a", "b", "c"]) == false
    end
  end
end
