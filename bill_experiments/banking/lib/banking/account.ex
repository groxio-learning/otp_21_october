defmodule Banking.Account do

  def new(amount), do: amount

  def deposit(balance, amount), do: balance + amount

  def withdrawl(balance, amount), do: balance - amount

end
