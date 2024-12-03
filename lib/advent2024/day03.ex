defmodule Advent2024.Day03 do
  def input() do
    "inputs/day03.txt"
    |> File.read!()
  end

  def problem_1() do
    input()
    |> scan_muls()
    |> List.flatten()
    |> Enum.map(fn m ->
      m
      |> String.replace("mul(", "")
      |> String.replace(")", "")
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.product()
    end)
    |> Enum.sum()
  end

  def problem_2() do
    input()
    |> bin_scan_muls()
  end

  @mul_regex ~r/mul\(\d{1,3},\d{1,3}\)/
  def scan_muls(input) do
    Regex.scan(@mul_regex, input)
  end

  # Keep running accumulator for multiplies
  def bin_scan_muls(input) do
    scan_enabled(input, 0)
  end

  # If we see a don't() we disable until a do()
  def scan_enabled("don't()" <> rest, acc) do
    scan_disabled(rest, acc)
  end

  def scan_enabled("mul(" <> rest, acc) do
    found_mul(rest, "", nil, acc)
  end

  def scan_enabled(<<_x::binary-size(1), rest::binary>>, acc) do
    scan_enabled(rest, acc)
  end

  def scan_enabled("", acc) do
    acc
  end

  # If we see a do we are enabled now
  def scan_disabled("do()" <> rest, acc) do
    scan_enabled(rest, acc)
  end

  def scan_disabled(<<_x::binary-size(1), rest::binary>>, acc) do
    scan_disabled(rest, acc)
  end

  def scan_disabled("", acc) do
    acc
  end

  def found_mul(")" <> rest, buffer, num1, acc) do
    case Integer.parse(buffer) do
      {num, ""} ->
        scan_enabled(rest, acc + num1 * num)

      _ ->
        scan_enabled(rest, acc)
    end
  end

  # Buffer should be a 1-3 digit number
  def found_mul("," <> rest, buffer, _num1, acc) do
    case Integer.parse(buffer) do
      {num, ""} ->
        found_mul(rest, "", num, acc)

      _ ->
        scan_enabled(rest, acc)
    end
  end

  def found_mul(<<x::binary-size(1), rest::binary>>, buffer, num1, acc) do
    # If we've consumed more than 3 bytes, this mul is bad
    if byte_size(buffer <> x) > 3 do
      scan_enabled(rest, acc)
    else
      found_mul(rest, buffer <> x, num1, acc)
    end
  end
end
