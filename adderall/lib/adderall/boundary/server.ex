defmodule Adderall.Boundary.Server do
  use GenServer

  alias Adderall.Core.Counter

  # Callbacks

  @impl true
  def init(count)  when is_integer(count) do
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
end
