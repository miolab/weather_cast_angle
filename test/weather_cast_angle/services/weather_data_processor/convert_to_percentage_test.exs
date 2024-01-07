defmodule WeatherCastAngle.Services.WeatherDataProcessor.ConvertToPercentageTest do
  use ExUnit.Case

  test "Converts float probabilities correctly." do
    assert WeatherCastAngle.Services.WeatherDataProcessor.convert_to_percentage(0.03) == 0
    assert WeatherCastAngle.Services.WeatherDataProcessor.convert_to_percentage(0.51) == 50
    assert WeatherCastAngle.Services.WeatherDataProcessor.convert_to_percentage(0.94) == 90
    assert WeatherCastAngle.Services.WeatherDataProcessor.convert_to_percentage(0.95) == 90
    assert WeatherCastAngle.Services.WeatherDataProcessor.convert_to_percentage(0.96) == 100
  end

  test "Converts other float probabilities with one decimal correctly." do
    assert WeatherCastAngle.Services.WeatherDataProcessor.convert_to_percentage(0.3) == 30
    assert WeatherCastAngle.Services.WeatherDataProcessor.convert_to_percentage(0.5) == 50
  end

  test "Converts integer probabilities correctly." do
    assert WeatherCastAngle.Services.WeatherDataProcessor.convert_to_percentage(0) == 0
    assert WeatherCastAngle.Services.WeatherDataProcessor.convert_to_percentage(1) == 100
  end
end
