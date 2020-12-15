defmodule ZehChallenge.StringUtilTest do
  use ExUnit.Case
  alias ZehChallenge.StringUtil

  test "blank?/1 with value" do
    assert StringUtil.blank?("any") == false
  end

  test "blank?/1 with empty value" do
    assert StringUtil.blank?("   ") == true
  end

  test "blank?/1 with nil value" do
    assert StringUtil.blank?(nil) == true
  end
end
