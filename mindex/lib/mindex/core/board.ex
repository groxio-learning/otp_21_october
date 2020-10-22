defmodule Mindex.Core.Board do
  defstruct answer: [], guesses: []

  def new, do: %__MODULE__{answer: Enum.shuffle(1..4)}

  def new([_a, _b, _c, _d] = answer), do: %__MODULE__{answer: answer}

  def move(board, guess), do: %{board | guesses: [guess | board.guesses]}
end
