defmodule WeatherCastAngle.Services.DatetimeProcessor.GetYesterdayStringTest do
  use ExUnit.Case
  use Mimic

  test "Get yesterday date and return the YYYY-MM-DD formatted date string." do
    stub(
      Timex,
      :now,
      fn "Asia/Tokyo" -> DateTime.from_naive!(~N[2025-01-01 12:00:00], "Asia/Tokyo") end
    )

    assert WeatherCastAngle.Services.DatetimeProcessor.get_yesterday_string_from_current() ==
             "2024-12-31"
  end
end
