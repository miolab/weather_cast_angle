defmodule WeatherCastAngle.Utils.DatetimeProcessor.ConvertUnixToHourMinuteFormatTest do
  use ExUnit.Case

  alias WeatherCastAngle.Utils.DatetimeProcessor

  test "Convert UNIX UTC timestamp to JST HH:mm formatted time string." do
    assert DatetimeProcessor.convert_unix_to_hour_minute_format(1_709_806_645) == "19:17"
    assert DatetimeProcessor.convert_unix_to_hour_minute_format(1_719_760_049) == "00:07"
  end
end
