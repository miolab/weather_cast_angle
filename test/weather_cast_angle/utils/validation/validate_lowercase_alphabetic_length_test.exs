defmodule WeatherCastAngle.Utils.Validation.ValidateLowercaseAlphabeticLengthTest do
  use ExUnit.Case
  alias WeatherCastAngle.Utils

  doctest WeatherCastAngle.Utils.Validation

  test "Returns `:ok` for valid uppercase alphanumeric string within length bounds" do
    assert Utils.Validation.validate_lowercase_alphabetic_length("abc", 1, 10) == :ok
    assert Utils.Validation.validate_lowercase_alphabetic_length("abc", 1, 3) == :ok
    assert Utils.Validation.validate_lowercase_alphabetic_length("abc", 3, 3) == :ok
    assert Utils.Validation.validate_lowercase_alphabetic_length("abc", 3, 10) == :ok
  end

  test "Returns error for string shorter than min length" do
    assert Utils.Validation.validate_lowercase_alphabetic_length("a", 3, 10) ==
             {:error, "The value must be at least 3 characters long."}

    assert Utils.Validation.validate_lowercase_alphabetic_length("a", 10, 15) ==
             {:error, "The value must be at least 10 characters long."}
  end

  test "Returns error for string longer than max length" do
    assert Utils.Validation.validate_lowercase_alphabetic_length("abcde", 1, 2) ==
             {:error, "The value must be no more than 2 characters long."}

    assert Utils.Validation.validate_lowercase_alphabetic_length("abcde", 1, 4) ==
             {:error, "The value must be no more than 4 characters long."}
  end

  test "Returns error for string with non-lowercase letters" do
    assert Utils.Validation.validate_lowercase_alphabetic_length("Abc", 1, 10) ==
             {:error, "The value must consist of lowercase alphabetic characters only."}

    assert Utils.Validation.validate_lowercase_alphabetic_length("abc123", 1, 10) ==
             {:error, "The value must consist of lowercase alphabetic characters only."}

    assert Utils.Validation.validate_lowercase_alphabetic_length("ab-cd", 1, 10) ==
             {:error, "The value must consist of lowercase alphabetic characters only."}

    assert Utils.Validation.validate_lowercase_alphabetic_length("ab_cd", 1, 10) ==
             {:error, "The value must consist of lowercase alphabetic characters only."}

    assert Utils.Validation.validate_lowercase_alphabetic_length("<abcd>", 1, 10) ==
             {:error, "The value must consist of lowercase alphabetic characters only."}

    assert Utils.Validation.validate_lowercase_alphabetic_length("ab cd", 1, 10) ==
             {:error, "The value must consist of lowercase alphabetic characters only."}
  end

  test "Returns error when min is greater than max" do
    assert Utils.Validation.validate_lowercase_alphabetic_length("abc", 4, 1) ==
             {:error,
              "Invalid parameters: min must be at least 1 and max must be equal to or greater integer than min."}
  end

  test "Returns error when min is less than 1" do
    assert Utils.Validation.validate_lowercase_alphabetic_length("abc", 0, 5) ==
             {:error,
              "Invalid parameters: min must be at least 1 and max must be equal to or greater integer than min."}
  end

  test "Returns error when min or max is not integer" do
    assert Utils.Validation.validate_lowercase_alphabetic_length("abc", 1, 10.5) ==
             {:error,
              "Invalid parameters: min must be at least 1 and max must be equal to or greater integer than min."}

    assert Utils.Validation.validate_lowercase_alphabetic_length("abc", 1.5, 10) ==
             {:error,
              "Invalid parameters: min must be at least 1 and max must be equal to or greater integer than min."}

    assert Utils.Validation.validate_lowercase_alphabetic_length(
             "abc",
             "1",
             "10"
           ) ==
             {:error,
              "Invalid parameters: min must be at least 1 and max must be equal to or greater integer than min."}
  end
end
