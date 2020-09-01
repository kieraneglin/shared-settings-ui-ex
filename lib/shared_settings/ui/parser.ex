defmodule SharedSettings.UI.Parser do
  @moduledoc false

  def parse_value("boolean", value) do
    value == "1"
  end

  def parse_value("string", value) do
    value
  end

  def parse_value("number", value) do
    if String.contains?(value, ".") do
      String.to_float(value)
    else
      String.to_integer(value)
    end
  end

  def parse_value("range", value) do
    [lower, upper] =
      value
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    lower..upper
  end
end
