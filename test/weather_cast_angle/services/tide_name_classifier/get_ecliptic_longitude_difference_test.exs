defmodule WeatherCastAngle.Services.TideNameClassifier.GetEclipticLongitudeDifferenceTest do
  use ExUnit.Case

  alias WeatherCastAngle.Services.TideNameClassifier

  describe "Classifies tide name correctly based on angle." do
    test "returns '大潮' for a date with a valid longitude difference in '大潮' range" do
      actual = TideNameClassifier.get_ecliptic_longitude_difference("2025-01-01")
      assert actual == "大潮"
    end

    test "returns '中潮' for a date with a valid longitude difference in '中潮' range" do
      actual = TideNameClassifier.get_ecliptic_longitude_difference("2025-01-03")
      assert actual == "中潮"
    end

    test "returns '小潮' for a date with a valid longitude difference in '小潮' range" do
      actual = TideNameClassifier.get_ecliptic_longitude_difference("2025-01-06")
      assert actual == "小潮"
    end

    test "returns '長潮' for a date with a valid longitude difference in '長潮' range" do
      actual = TideNameClassifier.get_ecliptic_longitude_difference("2025-01-08")
      assert actual == "長潮"
    end

    test "returns '若潮' for a date with a valid longitude difference in '若潮' range" do
      actual = TideNameClassifier.get_ecliptic_longitude_difference("2025-01-09")
      assert actual == "若潮"
    end
  end
end
