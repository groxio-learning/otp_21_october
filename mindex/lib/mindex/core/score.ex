defmodule Mindex.Core.Score do
  @red "R"
  @white "W"
  @blank "-"
  @max_length 4

  defstruct red: 0, white: 0

  # add guard to ensure guess and answer have 4 integers each (in the range of 1..8)
  def new(guess \\ [1, 3, 5, 8], answer \\ [1, 2, 3, 4]) do
    __struct__(red: count_red(guess, answer), white: count_white(guess, answer))
  end

  def render_string(%{red: red, white: white}) do
    @red
    |> String.duplicate(red)
    |> Kernel.<>(String.duplicate(@white, white))
    |> Kernel.<>(String.duplicate(@blank, @max_length - red - white))
  end

  defp count_red(guess, answer) do
    guess
    # [{1, 1}, {3, 2}, {5, 3}, {8, 4}]
    |> Enum.zip(answer)
    |> Enum.count(fn {x, y} -> x == y end)
  end

  defp count_white(guess, answer) do
    # 5 & 8 are not in the aswer (1 is correct & 3 wrong place)
    size_count = Enum.count(answer)
    # [5, 8] = [1, 3, 5, 8] -- [1, 2, 3, 4]
    miss_count =
      (guess -- answer)
      |> Enum.count()

    # if we use count_red then order is unimportant
    red_count = count_red(guess, answer)

    size_count - red_count - miss_count
  end
end
