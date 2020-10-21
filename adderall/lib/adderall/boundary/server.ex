defmodule Adderall.Boundary.Server do
  use GenServer

  alias Adderall.Core.Counter

  # Callbacks

  @impl true
  def init(count) when is_integer(count) do
    {:ok, count}
  end

  def init(_count), do: {:error, :blow_up}

  @impl true
  def handle_call(:get, _from, count) do
    {:reply, count, count}
  end

  @impl true
  def handle_cast(:inc, count) do
    {:noreply, Counter.increment(count)}
  end

  # APIs

  def start_link(count), do: GenServer.start_link(__MODULE__, count)

  def increment(counter), do: GenServer.cast(counter, :inc)

  def get(counter), do: GenServer.call(counter, :get)
end
