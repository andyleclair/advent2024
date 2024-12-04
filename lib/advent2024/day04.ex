defmodule Advent2024.Day04 do
  def input() do
    "inputs/day04.txt"
    |> File.read!()
  end

  def problem_1() do
    input()
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(fn line -> String.split(line, "", trim: true) |> :array.from_list() end)
    |> :array.from_list()
    |> find_xmases()
  end

  def problem_2() do
    input()
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(fn line -> String.split(line, "", trim: true) |> :array.from_list() end)
    |> :array.from_list()
    |> find_x_mases()
  end

  # Looking for X-MAS meaning
  # M . M
  # . A .
  # S . S
  def find_x_mases(input) do
    size = :array.size(input) - 1

    for i <- 0..size, reduce: 0 do
      outer_acc ->
        line = :array.get(i, input)
        inner_size = :array.size(line) - 1

        found =
          for j <- 0..inner_size, reduce: 0 do
            inner_acc ->
              char = :array.get(j, line)

              if char == "A" do
                if find_x_mas(input, i, j) do
                  inner_acc + 1
                else
                  inner_acc
                end
              else
                inner_acc
              end
          end

        outer_acc + found
    end
  end

  # Looking for XMAS
  def find_xmases(input) do
    size = :array.size(input) - 1

    for i <- 0..size, reduce: 0 do
      outer_acc ->
        line = :array.get(i, input)
        inner_size = :array.size(line) - 1

        found =
          for j <- 0..inner_size, reduce: 0 do
            inner_acc ->
              char = :array.get(j, line)

              if char == "X" do
                inner_acc + find_mas(input, i, j)
              else
                inner_acc
              end
          end

        outer_acc + found
    end
  end

  # We need to look in every direction for an MAS now that we have an X
  def find_mas(input, x, y) do
    for dir <- 0..7, reduce: 0 do
      acc ->
        {x, y} = next_from_dir(x, y, dir)
        char = get_char(input, x, y)

        if char == "M" do
          {x, y} = next_from_dir(x, y, dir)
          char = get_char(input, x, y)

          if char == "A" do
            {x, y} = next_from_dir(x, y, dir)

            if get_char(input, x, y) == "S" do
              acc + 1
            else
              acc
            end
          else
            acc
          end
        else
          acc
        end
    end
  end

  # we only need to look in the 4 diagonal directions
  # from the current point
  def find_x_mas(input, x, y) do
    upper_left = get_char(input, x - 1, y - 1)
    upper_right = get_char(input, x + 1, y - 1)
    lower_left = get_char(input, x - 1, y + 1)
    lower_right = get_char(input, x + 1, y + 1)

    (upper_left == "M" and upper_right == "M" and lower_right == "S" and lower_left == "S") or
      (upper_left == "S" and upper_right == "S" and lower_right == "M" and lower_left == "M") or
      (upper_left == "S" and upper_right == "M" and lower_right == "M" and lower_left == "S") or
      (upper_left == "M" and upper_right == "S" and lower_right == "S" and lower_left == "M")
  end

  def get_char(input, x, y) when x >= 0 and y >= 0 do
    line = :array.get(x, input)

    if line != :undefined do
      :array.get(y, line)
    else
      :undefined
    end
  end

  def get_char(_, _, _) do
    :undefined
  end

  # we define a direction as one of the 8 (0-7) possible directions
  # from the current point
  # 0 1 2
  # 3 X 4
  # 5 6 7
  def next_from_dir(x, y, 0) do
    {x - 1, y - 1}
  end

  def next_from_dir(x, y, 1) do
    {x, y - 1}
  end

  def next_from_dir(x, y, 2) do
    {x + 1, y - 1}
  end

  def next_from_dir(x, y, 3) do
    {x - 1, y}
  end

  def next_from_dir(x, y, 4) do
    {x + 1, y}
  end

  def next_from_dir(x, y, 5) do
    {x - 1, y + 1}
  end

  def next_from_dir(x, y, 6) do
    {x, y + 1}
  end

  def next_from_dir(x, y, 7) do
    {x + 1, y + 1}
  end
end
