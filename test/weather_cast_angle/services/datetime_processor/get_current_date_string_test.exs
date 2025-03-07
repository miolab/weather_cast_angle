defmodule WeatherCastAngle.Services.DatetimeProcessor.GetCurrentDateStringTest do
  use ExUnit.Case
  use Mimic

  alias WeatherCastAngle.Services.DatetimeProcessor

  test "Get current date and return the YYYY-MM-DD formatted date string." do
    stub(
      Timex,
      :now,
      fn "Asia/Tokyo" -> DateTime.from_naive!(~N[2023-01-01 12:00:00], "Asia/Tokyo") end
    )

    assert DatetimeProcessor.get_current_date_string() == "2023-01-01"
  end
end
