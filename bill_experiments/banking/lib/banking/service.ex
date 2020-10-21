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

  @impl true
  def handle_call({:deposit, amount}, _from, balance) do
    new_balance = Account.deposit(balance, amount)
    {:reply, new_balance, new_balance}
  end

  @impl true
  def handle_call({:withdrawl, amount}, _from, balance) do
    new_balance = Account.withdrawl(balance, amount)
    {:reply, new_balance, new_balance}
  end


  # API
  def start_link(initial_amount \\ 0) do
    GenServer.start_link(__MODULE__, initial_amount)
  end

  def balance(account) do
    {:ok, GenServer.call(account, :balance)}
  end

  def deposit(account, amount) do
    {:ok, GenServer.call(account, {:deposit, amount})}
  end

  def withdrawl(account, amount) do
    # new_balance = GenServer.call(account, {:withdrawl, amount})
    # if new_balance >= 0 do
    #   {:ok, new_balance}
    # else
    #   GenServer.call(account, {:deposit, amount})
    #   {:error, "insufficient funds"}
    # end

    # https://til.hashrocket.com/posts/ipq42kdcx8-with-statement-has-an-else-clause
    # https://blog.sundaycoding.com/blog/2017/12/27/elixir-with-syntax-and-guard-clauses/
    with balance when (balance >= 0) <- GenServer.call(account, {:withdrawl, amount}) do
      {:ok, balance}
    else
      _ ->
        GenServer.call(account, {:deposit, amount})
        {:error, "insufficient funds"}
    end
  end

  # would having a handler be safer?  Is this when not to use?
  def transfer(from_account, to_account, amount) do
    result = withdrawl(from_account, amount)
    case result do
      {:error, _} ->
        result
      {:ok, _}    ->
        deposit(to_account, amount)
    end
  end

end
