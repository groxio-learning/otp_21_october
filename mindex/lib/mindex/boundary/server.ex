defmodule Mindex.Boundary.Server do
  use GenServer
  alias Mindex.Core.Board

  def init(_board), do: {:ok, Board.new()}

  def handle_call({:move, guess}, _from, board) do
    new_board = Board.move(board, guess)
    {:reply, Board.to_string(new_board), new_board}
  end

  def handle_cast(:boom, _board), do: raise("boom")

  def start_link(board) do
    GenServer.start_link(__MODULE__, board, name: __MODULE__)
  end

  def move(guess) do
    GenServer.call(__MODULE__, {:move, guess})
  end

  def boom(), do: GenServer.cast(__MODULE__, :boom)
end
