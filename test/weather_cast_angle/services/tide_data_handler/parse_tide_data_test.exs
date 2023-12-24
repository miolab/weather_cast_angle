defmodule WeatherCastAngle.Services.TideDataHandler.ParseTideDataTest do
  use ExUnit.Case

  test "Parses tide data correctly" do
    actual =
      WeatherCastAngle.Services.TideDataHandler.parse_tide_data(
        " 76 99123141151152143129112 97 89 -1100118139156165167160145121 93 68 5123 1 1AB 4321521642167999999999999991027-102338 4899999999999999"
      )

    expected = %{
      hourly_tide_levels: [
        76,
        99,
        123,
        141,
        151,
        152,
        143,
        129,
        112,
        97,
        89,
        -1,
        100,
        118,
        139,
        156,
        165,
        167,
        160,
        145,
        121,
        93,
        68,
        51
      ],
      location_code: "AB",
      target_date: "2023-01-01",
      high_tide: [{"04:32", 152}, {"16:42", 167}, {"99:99", 999}, {"99:99", 999}],
      low_tide: [{"10:27", -10}, {"23:38", 48}, {"99:99", 999}, {"99:99", 999}]
    }

    assert actual == expected
  end
end
