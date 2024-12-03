defmodule Advent2024.Day01 do
  def input() do
    "inputs/day01.txt"
    |> File.read!()
    |> parse()
  end

  def parse(input, acc \\ {[], []})

  def parse("", acc) do
    acc
  end

  def parse(
        <<first::binary-size(5), "   ", second::binary-size(5), "\r\n", rest::binary>>,
        {left_list, right_list}
      ) do
    parse(
      rest,
      {[String.to_integer(first) | left_list], [String.to_integer(second) | right_list]}
    )
  end

  def problem_1() do
    {left_list, right_list} = input()

    left_sorted = Enum.sort(left_list)
    right_sorted = Enum.sort(right_list)

    Enum.zip(left_sorted, right_sorted)
    |> Enum.map(fn {left, right} -> abs(left - right) end)
    |> Enum.sum()
  end

  def problem_2() do
    {left_list, right_list} = input()

    occurrences = Enum.frequencies(right_list)

    Enum.reduce(left_list, 0, fn x, acc ->
      case Map.get(occurrences, x) do
        nil -> acc
        n -> acc + x * n
      end
    end)
  end
end
