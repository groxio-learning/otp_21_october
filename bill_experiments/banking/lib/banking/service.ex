defmodule Banking.Service do
  alias Banking.Account
  use GenServer

  # Callbacks
  @impl true
  def init(start_balance \\ 0) do
    {:ok, start_balance}
  end

  @impl true
  def handle_call(:balance, _from, balance) do
    {:reply, balance, balance}
  end

  # @impl true
  # def handle_call({:transfer, amount, other_account}, _from, balance) do
  #   balance = Account.witdrawl(amount)
  #
  #   {:reply, balance, balance}
  # end

  @impl true
  def handle_cast({:deposit, amount}, balance) do
    {:noreply, Account.deposit(balance, amount)}
  end

  @impl true
  def handle_cast({:withdrawl, amount}, balance) do
    {:noreply, Account.withdrawl(balance, amount)}
  end

  # API
  def start_link(initial_amount \\ 0), do: GenServer.start_link(__MODULE__, initial_amount)
  def deposit(account, amount),   do: GenServer.cast(account, {:deposit, amount})
  def withdrawl(account, amount), do: GenServer.cast(account, {:withdrawl, amount})
  def balance(account),           do: GenServer.call(account, :balance)
  # would having a handler be safer?  Is this when not to use?
  def transfer(from_account, to_account, amount) do
    # check that there is enough money
    _response_withdrawl = withdrawl(from_account, amount)
    # if withdrawl ok then deposit (rollback if account is closed or not available)
    _response_deposit   = deposit(to_account, amount)
    # unless both match :ok - rollback transactions
  end

end
