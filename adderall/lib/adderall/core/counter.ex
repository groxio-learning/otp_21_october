defmodule Adderall.Core.Counter do
  # defstruct [] # in most complex cases

  def new, do: 0

  def increment(amount) do
    amount + 1
  end
end
