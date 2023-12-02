defmodule WeatherCastAngle.Services.ResponseProcessor.ParsedLinesArrayTest do
  use ExUnit.Case

  test "When multiple lines, each line can be divided and stored in an array." do
    actual_text = """
    sample report 01
    sample report 02
    sample report 03
    """

    assert WeatherCastAngle.Services.ResponseProcessor.parsed_lines_array(actual_text) == [
             "sample report 01",
             "sample report 02",
             "sample report 03"
           ]
  end

  test "When single line, the line can be stored in an array." do
    actual_text = "sample report single line"

    assert WeatherCastAngle.Services.ResponseProcessor.parsed_lines_array(actual_text) == [
             "sample report single line"
           ]
  end
end
