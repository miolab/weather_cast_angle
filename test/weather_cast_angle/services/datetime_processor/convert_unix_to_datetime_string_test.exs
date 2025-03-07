defmodule WeatherCastAngle.Services.DatetimeProcessor.ConvertUnixToDatetimeStringTest do
  use ExUnit.Case

  alias WeatherCastAngle.Services.DatetimeProcessor

  test "Convert UNIX UTC timestamp to JST yyyy-mm-dd HH formatted datetime string." do
    actual = DatetimeProcessor.convert_unix_to_datetime_string(1_703_974_859)

    assert actual == "2023-12-31 07"
  end
end
