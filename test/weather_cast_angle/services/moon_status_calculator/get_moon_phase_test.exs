defmodule WeatherCastAngle.Services.MoonStatusCalculator.GetMoonPhaseTest do
  use ExUnit.Case

  describe "Calculates the moon phase." do
    @tokyo_latitude 35.689499
    @tokyo_longitude 139.691711

    test "Can return new moon." do
      actual =
        WeatherCastAngle.Services.MoonStatusCalculator.get_moon_phase(
          "2024-01-11",
          @tokyo_latitude,
          @tokyo_longitude
        )

      assert actual == "新月"
    end

    test "Can return full moon." do
      actual =
        WeatherCastAngle.Services.MoonStatusCalculator.get_moon_phase(
          "2024-01-26",
          @tokyo_latitude,
          @tokyo_longitude
        )

      assert actual == "満月"
    end

    test "If it is neither a full nor a new moon, returns a empty character." do
      actual =
        WeatherCastAngle.Services.MoonStatusCalculator.get_moon_phase(
          "2024-01-18",
          @tokyo_latitude,
          @tokyo_longitude
        )

      assert actual == ""
    end
  end
end
