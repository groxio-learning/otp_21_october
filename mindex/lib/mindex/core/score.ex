defmodule Mindex.Core.Score do
  defstruct red: 0, white: 0

  def new(guess, answer), do: __struct__

  def score(val), do: to_string(val)
end
