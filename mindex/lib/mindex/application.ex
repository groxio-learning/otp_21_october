defmodule Mindex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Mindex.Worker.start_link(arg)
      # https://hexdocs.pm/elixir/DynamicSupervisor.html
      {DynamicSupervisor, strategy: :one_for_one, name: Chefe}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    # restart strategy: the_strategy      Supervisor_name
    #                        |                 |
    opts = [strategy: :rest_for_one, name: Mindex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
