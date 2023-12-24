defmodule WeatherCastAngle.Services.TideDataHandler.ParsedLinesArrayTest do
  use ExUnit.Case

  test "When multiple lines, each line can be divided and stored in an array." do
    actual_text = """
    sample report 01
    sample report 02
    sample report 03
    """

    assert WeatherCastAngle.Services.TideDataHandler.parsed_lines_array(actual_text) == [
             "sample report 01",
             "sample report 02",
             "sample report 03"
           ]
  end

  test "When single line, the line can be stored in an array." do
    actual_text = "sample report single line"

    assert WeatherCastAngle.Services.TideDataHandler.parsed_lines_array(actual_text) == [
             "sample report single line"
           ]
  end

  test "When input string is empty, returns a list containing only empty string." do
    assert WeatherCastAngle.Services.TideDataHandler.parsed_lines_array("") == [""]
  end
end
