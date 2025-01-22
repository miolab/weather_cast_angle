defmodule WeatherCastAngle.Services.DatetimeProcessor.IsCurrentDateTest do
  use ExUnit.Case
  use Mimic

  alias WeatherCastAngle.Services.DatetimeProcessor

  test "Return the date is current date or not." do
    stub(
      Timex,
      :now,
      fn "Asia/Tokyo" -> DateTime.from_naive!(~N[2025-01-01 12:00:00], "Asia/Tokyo") end
    )

    assert DatetimeProcessor.is_current_date("2025-01-01") == true
    assert DatetimeProcessor.is_current_date("2030-12-31") == false
  end
end
