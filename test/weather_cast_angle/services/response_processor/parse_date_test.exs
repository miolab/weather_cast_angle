defmodule WeatherCastAngle.Services.ResponseProcessor.ParseDateTest do
  use ExUnit.Case

  test "It Can Convert date string YYMMDD to YYYY-MM-DD format" do
    assert WeatherCastAngle.Services.ResponseProcessor.parse_date("241010") == "2024-10-10"
    assert WeatherCastAngle.Services.ResponseProcessor.parse_date("2410 1") == "2024-10-01"
    assert WeatherCastAngle.Services.ResponseProcessor.parse_date("24 1 1") == "2024-01-01"
  end
end
