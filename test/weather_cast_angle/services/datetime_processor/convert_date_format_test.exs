defmodule WeatherCastAngle.Services.DatetimeProcessor.ConvertDateFormatTest do
  use ExUnit.Case

  alias WeatherCastAngle.Services.DatetimeProcessor

  test "Convert date string YYMMDD to YYYY-MM-DD format." do
    assert DatetimeProcessor.convert_date_format("231231") == "2023-12-31"
  end

  test "If a single-byte space is retained, it is filled with 0." do
    assert DatetimeProcessor.convert_date_format("23 1 1") == "2023-01-01"
  end
end
