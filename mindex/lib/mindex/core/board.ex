defmodule Mindex.Core.Board do
  defstruct answer: [], guesses: []

  def new(answer \\ [1, 2, 3, 4]), do: %__MODULE__{answer: answer}

  def move(board, guess) do
    %{board | guesses: [guess | board.guesses]}
  end
end
