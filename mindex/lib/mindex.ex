defmodule Mindex do
  @moduledoc """
  Documentation for `Mindex`.
  """

  alias Mindex.Boundary.Server

  def add_game(name) do
    DynamicSupervisor.start_child(Chefe, {Server, name})
  end
end
