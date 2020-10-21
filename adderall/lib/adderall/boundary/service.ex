defmodule Adderall.Boundary.Service do
  alias Adderall.Core.Counter

  def start(count \\ Counter.new()) do
    spawn(fn -> run(count) end)
  end

  def run(count) do
    count
    |> listen()
    |> run()
  end

  def listen(count) do
    receive do
      :increment ->
        Counter.increment(count)
      {:get, from} ->
        send from, count
        count
    end
  end
end
