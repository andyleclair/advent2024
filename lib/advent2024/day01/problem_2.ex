defmodule Advent2024.Day01.Problem2 do
  @input Advent2024.input()

  def run() do
    {left_list, right_list} = Enum.unzip(@input)

    occurrences = occurrences(right_list)

    Enum.reduce(left_list, 0, fn x, acc ->
      case Map.get(occurrences, x) do
        nil -> acc
        n -> acc + x * n
      end
    end)
  end

  def occurrences(list) do
    list
    |> Enum.reduce(%{}, fn x, acc ->
      Map.update(acc, x, 1, &(&1 + 1))
    end)
  end
end
