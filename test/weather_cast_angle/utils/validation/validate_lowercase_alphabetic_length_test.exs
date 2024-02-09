defmodule WeatherCastAngle.Utils.Validation.ValidateLowercaseAlphabeticLengthTest do
  use ExUnit.Case

  test "Returns `:ok` for valid uppercase alphanumeric string within length bounds" do
    assert WeatherCastAngle.Utils.Validation.validate_lowercase_alphabetic_length(
             "abc",
             1,
             10
           ) == :ok

    assert WeatherCastAngle.Utils.Validation.validate_lowercase_alphabetic_length(
             "abc",
             1,
             3
           ) == :ok

    assert WeatherCastAngle.Utils.Validation.validate_lowercase_alphabetic_length(
             "abc",
             3,
             3
           ) == :ok

    assert WeatherCastAngle.Utils.Validation.validate_lowercase_alphabetic_length(
             "abc",
             3,
             10
           ) == :ok
  end
end
