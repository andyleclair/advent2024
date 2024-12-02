defmodule Advent2024.Day01.Problem1 do
  @input Advent2024.input()

  def run() do
    {left_list, right_list} = Enum.unzip(@input)

    left_sorted = Enum.sort(left_list)
    right_sorted = Enum.sort(right_list)

    Enum.zip(left_sorted, right_sorted)
    |> Enum.map(fn {left, right} -> abs(left - right) end)
    |> Enum.sum()
  end
end
