defmodule Mindex.Boundary.Server do
  use GenServer
  alias Mindex.Core.Board
        #   from the start_link (middle param)
        #     |
  def init(_unused) do
    IO.puts "Starting #{inspect self()}"
    {:ok, Board.new() |> IO.inspect(label: :init)}
  end

  def handle_call({:move, guess}, _from, board) do
    new_board = Board.move(board, guess)
    {:reply, Board.to_string(new_board), new_board}
  end

  def handle_cast(:boom, _board), do: raise("boom")

  def start_link(name) do
                    #               sent to init
                    # code reference,  |   server name (must be an atom) (otherwise use via-tuples)
                    #        |         |            |
    GenServer.start_link(__MODULE__, :unused, name: name)
  end

  def child_spec(name) do
    %{
      id: name,
      start: {Mindex.Boundary.Server, :start_link, [name]}
    }
    |> IO.inspect(label: :child_spec)
  end

  def move(name, guess) do
            # server name (in registry)
            #       |
    GenServer.call(name, {:move, guess})
  end

  def boom(name), do: GenServer.cast(name, :boom)
end
