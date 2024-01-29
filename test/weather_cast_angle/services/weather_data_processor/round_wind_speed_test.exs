defmodule WeatherCastAngle.Services.WeatherDataProcessor.RoundWindSpeedTest do
  use ExUnit.Case

  test "Rounds the given wind speed string to the nearest integer." do
    assert WeatherCastAngle.Services.WeatherDataProcessor.round_wind_speed(10.51) == 11
    assert WeatherCastAngle.Services.WeatherDataProcessor.round_wind_speed(2.51) == 3
    assert WeatherCastAngle.Services.WeatherDataProcessor.round_wind_speed(2.29) == 2
    assert WeatherCastAngle.Services.WeatherDataProcessor.round_wind_speed(1) == 1
    assert WeatherCastAngle.Services.WeatherDataProcessor.round_wind_speed(0.11) == 0
    assert WeatherCastAngle.Services.WeatherDataProcessor.round_wind_speed(0) == 0
  end
end
