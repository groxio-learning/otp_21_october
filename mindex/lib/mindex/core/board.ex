defmodule Mindex.Core.Board do
  alias Mindex.Core.Score

  defstruct answer: [], guesses: []

  def new, do: %__MODULE__{answer: random_answer()}

  def new([_a, _b, _c, _d] = answer), do: %__MODULE__{answer: answer}

  def random_answer, do: 1..8 |> Enum.shuffle() |> Enum.take(4)

  def move(board, guess), do: %{board | guesses: [guess | board.guesses]}

  def to_string(board), do: board |> status() |> build_string()

  defp status(%{answer: answer, guesses: guesses} = board) do
    %{won: won?(board), lost: lost?(board), rows: rows(guesses, answer)}
  end

  defp rows(guesses, answer), do: Enum.map(guesses, &row(&1, answer))

  defp row(guess, answer), do: %{guess: guess, score: Score.new(guess, answer)}

  def won?(%{guesses: [answer | _guesses], answer: answer}), do: true
  def won?(_board), do: false

  def lost?(board), do: !won?(board) and length(board.guesses) == 10

  defp build_string(%{rows: rows}), do: Enum.map(rows, &print_row/1)

  defp print_row(%{guess: guess, score: score}) do
    print_guess(guess)
    Score.render_string(score)
  end

  def print_guess([a, b, c, d]) do
    IO.inspect("Guess: #{a}, #{b}, #{c}, #{d}")
  end
end
