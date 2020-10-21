defmodule Adderall do
  alias Adderall.Core.Counter
  alias Adderall.Boundary.Service

  def start(count \\ Counter.new()) do
    Service.start(count)
  end

  def increment(counter) do
    send(counter, :increment)
  end

  def get(counter) do
    send(counter, {:get, self()})

    receive do
      message -> message
    end
  end
end
