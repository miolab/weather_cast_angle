defmodule WeatherCastAngle.Services.MoonStatusCalculator.GetMoonAgeTest do
  use ExUnit.Case

  describe "Calculates the moon age." do
    @tokyo_latitude 35.689499
    @tokyo_longitude 139.691711

    test "Can return moon age." do
      assert WeatherCastAngle.Services.MoonStatusCalculator.get_moon_age(
               "2023-12-13",
               @tokyo_latitude,
               @tokyo_longitude
             ) == 0.0

      assert WeatherCastAngle.Services.MoonStatusCalculator.get_moon_age(
               "2023-12-19",
               @tokyo_latitude,
               @tokyo_longitude
             ) == 6.0

      assert WeatherCastAngle.Services.MoonStatusCalculator.get_moon_age(
               "2024-01-11",
               @tokyo_latitude,
               @tokyo_longitude
             ) == 29.0

      assert WeatherCastAngle.Services.MoonStatusCalculator.get_moon_age(
               "2024-01-26",
               @tokyo_latitude,
               @tokyo_longitude
             ) == 14.5
    end
  end
end
