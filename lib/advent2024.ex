defmodule Advent2024 do
  @moduledoc """
  Shared helpers for Advent of Code 2024
  """

  def input() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(fn line ->
      [first, second] = String.split(line, ~r{\s}, trim: true)
      {String.to_integer(first), String.to_integer(second)}
    end)
  end
end
