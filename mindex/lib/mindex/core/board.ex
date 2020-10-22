defmodule Mindex.Core.Board do
  defstruct answer: [], guesses: []

  def new do
    random_answer = 1..8 |> Enum.shuffle() |> Enum.take(4)
    %__MODULE__{answer: random_answer}
  end

  def new([_a, _b, _c, _d] = answer), do: %__MODULE__{answer: answer}

  def move(board, guess), do: %{board | guesses: [guess | board.guesses]}
end
