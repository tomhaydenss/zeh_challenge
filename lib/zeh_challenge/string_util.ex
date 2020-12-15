defmodule ZehChallenge.StringUtil do
  def blank?(str_or_nil),
    do: "" == str_or_nil |> to_string() |> String.trim()
end
