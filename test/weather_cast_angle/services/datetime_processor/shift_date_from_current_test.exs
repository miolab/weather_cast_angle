defmodule WeatherCastAngle.Services.DatetimeProcessor.ShiftDateFromCurrentTest do
  use ExUnit.Case
  use Mimic

  alias WeatherCastAngle.Services.DatetimeProcessor

  test "Shift the date by any number of days from the current date." do
    stub(
      Timex,
      :now,
      fn "Asia/Tokyo" -> DateTime.from_naive!(~N[2025-01-01 12:00:00], "Asia/Tokyo") end
    )

    assert DatetimeProcessor.shift_date_from_current(0) == "2025-01-01"
    assert DatetimeProcessor.shift_date_from_current(1) == "2025-01-02"
    assert DatetimeProcessor.shift_date_from_current(2) == "2025-01-03"
  end
end
