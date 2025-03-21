defmodule WeatherCastAngle.Services.WeatherDataProcessor.WindDirectionTest do
  use ExUnit.Case

  alias WeatherCastAngle.Services.WeatherDataProcessor

  test "Convert the wind direction angle integer to an 8 wind direction notation." do
    assert WeatherDataProcessor.wind_direction(0) == "北"
    assert WeatherDataProcessor.wind_direction(180) == "南"
    assert WeatherDataProcessor.wind_direction(202) == "南"
    assert WeatherDataProcessor.wind_direction(203) == "南西"
    assert WeatherDataProcessor.wind_direction(359) == "北"
  end

  test "If an angle of more than 360 degrees or a float value is entered, it is indicated as invalid value." do
    assert WeatherDataProcessor.wind_direction(360) == ""
    assert WeatherDataProcessor.wind_direction(22.5) == ""
    assert WeatherDataProcessor.wind_direction(-45) == ""
    assert WeatherDataProcessor.wind_direction("10") == ""
  end
end
