defmodule Mindex.Core.Score do

  defstruct red: 0, white: 0, guess: [], answer: []

  def new(guess \\ [1, 3, 5, 8], answer \\ [1, 2, 3, 4]) do  # add guard to ensure guess and answer have 4 integers each (in the range of 1..8)
    %__MODULE__{guess: guess, answer: answer}
  end

  def render_string(score) do
    score
      |> update_red_score()
      |> update_white_score()
  end

  def update_red_score(score) do
    red_count = count_red(score)
    %{ score | red: red_count }
  end

  def update_white_score(score) do
    white_count = count_white(score)
    %{ score | white: white_count }
  end

  def count_red(score) do
    score.guess
      |> Enum.zip(score.answer)   # [{1, 1}, {3, 2}, {5, 3}, {8, 4}]
      |> Enum.count(fn {x, y} -> x == y end)
  end

  def count_white(score) do
    size_count = Enum.count(score.answer)      # 5 & 8 are not in the aswer (1 is correct & 3 wrong place)
    miss_count = (score.guess -- score.answer) # [5, 8] = [1, 3, 5, 8] -- [1, 2, 3, 4]
                |> Enum.count
    red_count  = count_red(score)              # if we use count_red then order is unimportant

    size_count - red_count - miss_count
  end

end
