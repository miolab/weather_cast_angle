defmodule WeatherCastAngle.Services.SeaWaterTemperatureProcessor.ConvertToSortedKeywordListTest do
  use ExUnit.Case

  test "Converts a map of date-temperature pairs into a sorted keyword list, maintaining the descending order of dates." do
    actual =
      WeatherCastAngle.Services.SeaWaterTemperatureProcessor.convert_to_sorted_keyword_list(%{
        "2024-01-05" => 16.9,
        "2024-01-06" => 16.8,
        "2024-01-07" => 16.7
      })

    assert actual == [{"2024-01-07", 16.7}, {"2024-01-06", 16.8}, {"2024-01-05", 16.9}]
  end
end
