defmodule WeatherCastAngle.Services.WeatherDataProcessor.WindDirectionTest do
  use ExUnit.Case

  test "Convert the wind direction angle integer to an 8 wind direction notation." do
    assert WeatherCastAngle.Services.WeatherDataProcessor.wind_direction(0) == "北"
    assert WeatherCastAngle.Services.WeatherDataProcessor.wind_direction(180) == "南"
    assert WeatherCastAngle.Services.WeatherDataProcessor.wind_direction(202) == "南"
    assert WeatherCastAngle.Services.WeatherDataProcessor.wind_direction(203) == "南西"
    assert WeatherCastAngle.Services.WeatherDataProcessor.wind_direction(359) == "北"
  end

  test "If an angle of more than 360 degrees or a float value is entered, it is indicated as invalid value." do
    assert WeatherCastAngle.Services.WeatherDataProcessor.wind_direction(360) == "Invalid value"
    assert WeatherCastAngle.Services.WeatherDataProcessor.wind_direction(22.5) == "Invalid value"
    assert WeatherCastAngle.Services.WeatherDataProcessor.wind_direction(-45) == "Invalid value"
    assert WeatherCastAngle.Services.WeatherDataProcessor.wind_direction("10") == "Invalid value"
  end
end
