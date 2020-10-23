defmodule Mindex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Mindex.Worker.start_link(arg)
      {Mindex.Boundary.Server, :bill},
      {Mindex.Boundary.Server, :bruce},
      {Mindex.Boundary.Server, :yuri},
      {Mindex.Boundary.Server, :karthikeyan},
      {Mindex.Boundary.Server, :sigu},
      {Mindex.Boundary.Server, :danilo},
      {Mindex.Boundary.Server, :giorgio}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    # restart strategy: the_strategy      Supervisor_name
    #                        |                 |
    opts = [strategy: :rest_for_one, name: Mindex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
