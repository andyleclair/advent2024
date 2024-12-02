defmodule Advent2024 do
  @moduledoc """
  Shared helpers for Advent of Code 2024
  """

  def input() do
    File.read!("input.txt")
    |> parse()
  end

  def parse(input, acc \\ [])

  def parse("", acc) do
    Enum.reverse(acc)
  end

  def parse(<<first::binary-size(5), "   ", second::binary-size(5), "\r\n", rest::binary>>, acc) do
    parse(rest, [{String.to_integer(first), String.to_integer(second)} | acc])
  end
end
