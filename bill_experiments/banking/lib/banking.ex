defmodule Banking do
  alias Banking.Service

  # response: {:ok, pid}
  def open_account(amount \\ 0),  do: Service.start_link(amount)

  # response: amount in account
  def balance(account), do: Service.balance(account)

  # response: {:ok}
  def deposit(account, amount),   do: Service.deposit(account, amount)
  def withdrawl(account, amount), do: Service.withdrawl(account, amount)
  def transfer(from_account, to_account, amount) do
    Service.transfer(from_account, to_account, amount)
  end

end
