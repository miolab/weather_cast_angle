defmodule WeatherCastAngle.Utils.Collection.NormalizeInnerMapKeysToAtomsTest do
  use ExUnit.Case
  alias WeatherCastAngle.Utils

  describe "Converts inner map keys from strings to atoms while keeping top level keys unchanged" do
    test "If the map value's top-level keys are string format, they can be converted to atom." do
      input_map = %{
        "2024-01-01" => %{
          "hourly_tide_levels" => [
            10,
            50,
            100
          ],
          "target_date" => "2024-01-01",
          "location_code" => "AB",
          "high_tide" => [
            %{"01:00" => 152},
            %{"13:00" => 167}
          ],
          "low_tide" => [
            %{"07:00" => -10},
            %{"19:00" => 48}
          ]
        }
      }

      assert Utils.Collection.normalize_inner_map_keys_to_atoms(input_map) == %{
               "2024-01-01" => %{
                 hourly_tide_levels: [
                   10,
                   50,
                   100
                 ],
                 target_date: "2024-01-01",
                 location_code: "AB",
                 high_tide: [
                   %{"01:00" => 152},
                   %{"13:00" => 167}
                 ],
                 low_tide: [
                   %{"07:00" => -10},
                   %{"19:00" => 48}
                 ]
               }
             }
    end

    test "If the map value's keys is already atom format, the original map is returned as is." do
      input_map = %{
        "2024-01-01" => %{
          hourly_tide_levels: [
            10,
            50,
            100
          ],
          target_date: "2024-01-01",
          location_code: "AB",
          high_tide: [
            %{"01:00" => 152},
            %{"13:00" => 167}
          ],
          low_tide: [
            %{"07:00" => -10},
            %{"19:00" => 48}
          ]
        }
      }

      assert Utils.Collection.normalize_inner_map_keys_to_atoms(input_map) == input_map
    end
  end

  test "If the argument is not a map, returns error." do
    assert Utils.Collection.normalize_inner_map_keys_to_atoms(["a", "b", "c"]) ==
             {:error, "The value must be Map."}
  end
end
