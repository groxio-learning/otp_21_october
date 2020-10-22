defmodule Mindex.Core.Board do
  alias Mindex.Core.Score

  defstruct answer: [], guesses: []

  def new(answer \\ [1, 2, 3, 4]), do: %__MODULE__{answer: answer}

  def move(board, guess) do
    board
  end

  def to_string(board), do: board |> status() |> build_string

  defp status(%{answer: answer, guesses: [guess | _tail] = rows}) when length(rows) < 10 do
    %{red: red} = Score.new(guess, answer)

    %{rows: rows, won: red == length(answer), lost: false}
  end

  defp status(%{answer: answer, guesses: [guess | _tail] = rows}) do
    %{white: white} = Score.new(guess, answer)

    %{rows: rows, won: white == 0, lost: white > 0}
  end

  defp build_string(_status), do: ""
end
