defmodule WeatherCastAngle.Utils.Validation.ValidateInArrayTest do
  use ExUnit.Case

  describe "Validate properly pattern" do
    test "Returns `:ok` when value is in the array" do
      assert WeatherCastAngle.Utils.Validation.validate_in_array("ab", ["ab", "cd", "ef"]) == :ok
      assert WeatherCastAngle.Utils.Validation.validate_in_array("", ["", "foo", "bar"]) == :ok
      assert WeatherCastAngle.Utils.Validation.validate_in_array(5, [1, 2, 3, 4, 5]) == :ok
      assert WeatherCastAngle.Utils.Validation.validate_in_array(0.1, [0.0, 0.1, 0.2]) == :ok
      assert WeatherCastAngle.Utils.Validation.validate_in_array(["b"], [["a"], ["b"]]) == :ok
    end
  end

  describe "Validate error pattern" do
    test "Returns `{:error, reason}` tuple when value is not in the array" do
      assert WeatherCastAngle.Utils.Validation.validate_in_array("z", ["a", "b", "c"]) ==
               {:error, "Value not found in array"}

      assert WeatherCastAngle.Utils.Validation.validate_in_array("", ["a", "b", "c"]) ==
               {:error, "Value not found in array"}

      assert WeatherCastAngle.Utils.Validation.validate_in_array(0, [1, 2, 3, 4, 5]) ==
               {:error, "Value not found in array"}

      assert WeatherCastAngle.Utils.Validation.validate_in_array(0, [0.0, 0.1, 0.2]) ==
               {:error, "Value not found in array"}

      assert WeatherCastAngle.Utils.Validation.validate_in_array([], [["a"], ["b"]]) ==
               {:error, "Value not found in array"}
    end

    test "Returns `{:error, reason}` tuple when array is not a list" do
      assert WeatherCastAngle.Utils.Validation.validate_in_array("ab", "abcde") ==
               {:error, "abcde must be a list"}
    end
  end
end
