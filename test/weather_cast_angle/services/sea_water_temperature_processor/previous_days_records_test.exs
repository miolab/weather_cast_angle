defmodule WeatherCastAngle.Services.SeaWaterTemperatureProcessor.PreviousDaysRecordsTest do
  use ExUnit.Case

  test "Generate a Map consisting of date and temperature." do
    raw_text = """
    yyyy,mm,dd,areaNo.,flag,Temp.
    2024,01,01,601,P, 16.86
    2024,01,02,601,P, 16.79
    2024,01,03,601,P, 16.75
    2024,01,04,601,P, 16.91
    2024,01,05,601,P, 16.91
    2024,01,06,601,P, 16.82
    2024,01,07,601,P, 16.71
    yyyy,mm,dd,areaNo.,flag,Temp.
    """

    actual =
      WeatherCastAngle.Services.SeaWaterTemperatureProcessor.previous_days_records(raw_text)

    assert actual == %{
             "2024-01-05" => 17,
             "2024-01-06" => 17,
             "2024-01-07" => 17
           }
  end
end
