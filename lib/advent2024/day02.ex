defmodule Advent2024.Day02 do
  def input() do
    "inputs/day02.txt"
    |> File.read!()
  end

  def problem_1() do
    input()
    |> safe_lines()
  end

  def problem_2() do
    input()
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(&(&1 |> String.split(" ") |> Enum.map(fn i -> String.to_integer(i) end)))
    |> Enum.map(fn line ->
      permutations =
        line |> Enum.with_index() |> Enum.map(fn {_i, idx} -> List.delete_at(line, idx) end)

      [line] ++ permutations
    end)
    # Now we are passed a list of lists
    |> Enum.map(fn lists ->
      # I thought I had a cute algo to do this in one pass but it ain't work
      if Enum.any?(lists, fn list -> safety(list, nil, nil) == 1 end) do
        1
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def safety(line, prev, direction)

  def safety([i | rest], nil, nil) do
    safety(rest, i, nil)
  end

  def safety([i | rest], prev, nil) do
    cond do
      safe?(:increasing, i, prev) ->
        safety(rest, i, :increasing)

      safe?(:decreasing, i, prev) ->
        safety(rest, i, :decreasing)

      :else ->
        0
    end
  end

  for direction <- [:increasing, :decreasing] do
    def safety([i | []], prev, unquote(direction)) do
      if safe?(unquote(direction), i, prev) do
        1
      else
        0
      end
    end

    def safety([i | rest], prev, unquote(direction)) do
      if safe?(unquote(direction), i, prev) do
        safety(rest, i, unquote(direction))
      else
        0
      end
    end
  end

  def safe_lines(input, buf \\ nil, direction \\ nil, acc \\ 0)

  def safe_lines("", _buf, _dir, acc) do
    acc
  end

  for size <- [1, 2] do
    # If no current number, parse then move on
    def safe_lines(<<num::binary-size(unquote(size)), " ", rest::binary>>, nil, _, acc) do
      num = String.to_integer(num)
      safe_lines(rest, num, nil, acc)
    end

    # If we have a previous number we can see if we are increasing or decreasing
    def safe_lines(<<num::binary-size(unquote(size)), " ", rest::binary>>, buf, nil, acc) do
      num = String.to_integer(num)

      cond do
        safe?(:increasing, num, buf) ->
          safe_lines(rest, num, :increasing, acc)

        safe?(:decreasing, num, buf) ->
          safe_lines(rest, num, :decreasing, acc)

        true ->
          unsafe_line(rest, acc)
      end
    end

    def safe_lines(<<num::binary-size(unquote(size)), " ", rest::binary>>, buf, :increasing, acc) do
      num = String.to_integer(num)

      if safe?(:increasing, num, buf) do
        safe_lines(rest, num, :increasing, acc)
      else
        unsafe_line(rest, acc)
      end
    end

    def safe_lines(<<num::binary-size(unquote(size)), " ", rest::binary>>, buf, :decreasing, acc) do
      num = String.to_integer(num)

      if safe?(:decreasing, num, buf) do
        safe_lines(rest, num, :decreasing, acc)
      else
        unsafe_line(rest, acc)
      end
    end

    def safe_lines(
          <<num::binary-size(unquote(size)), "\r\n", rest::binary>>,
          buf,
          :increasing,
          acc
        ) do
      num = String.to_integer(num)

      if safe?(:increasing, num, buf) do
        safe_lines(rest, nil, nil, acc + 1)
      else
        safe_lines(rest, nil, nil, acc)
      end
    end

    def safe_lines(
          <<num::binary-size(unquote(size)), "\r\n", rest::binary>>,
          buf,
          :decreasing,
          acc
        ) do
      num = String.to_integer(num)

      if safe?(:decreasing, num, buf) do
        safe_lines(rest, nil, nil, acc + 1)
      else
        safe_lines(rest, nil, nil, acc)
      end
    end
  end

  def safe?(:increasing, num, buf) do
    num > buf and (num - buf >= 1 and num - buf <= 3)
  end

  def safe?(:decreasing, num, buf) do
    num < buf and (buf - num >= 1 and buf - num <= 3)
  end

  # If we're unsafe, consume until newline then move on
  def unsafe_line("\n" <> rest, acc) do
    safe_lines(rest, nil, nil, acc)
  end

  def unsafe_line(<<_char, rest::binary>>, acc) do
    unsafe_line(rest, acc)
  end
end
