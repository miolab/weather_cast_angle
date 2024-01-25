defmodule WeatherCastAngle.Services.WeatherDataProcessor.KelvinToCelsiusTemperatureTest do
  use ExUnit.Case

  test "Converts a temperature from Kelvin float value to Celsius integer value." do
    actual = WeatherCastAngle.Services.WeatherDataProcessor.kelvin_to_celsius_temperature(287.71)
    assert actual == 15
  end

  test "Negative numbers can also be treated as targets." do
    actual = WeatherCastAngle.Services.WeatherDataProcessor.kelvin_to_celsius_temperature(267.71)
    assert actual == -5
  end
end
