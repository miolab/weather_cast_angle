defmodule WeatherCastAngle.Utils.Validation.ValidateDateFormatTest do
  use ExUnit.Case

  test "Validates correct date format." do
    assert WeatherCastAngle.Utils.Validation.validate_date_format("2024-01-01") == :ok
  end

  test "Rejects incorrect date format." do
    assert WeatherCastAngle.Utils.Validation.validate_date_format("2024-1-1") ==
             {:error, "Invalid date format"}

    assert WeatherCastAngle.Utils.Validation.validate_date_format("24-01-01") ==
             {:error, "Invalid date format"}
  end
end
