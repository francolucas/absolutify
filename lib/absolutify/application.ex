defmodule Absolutify.Application do
  use Application

  alias Absolutify.State

  def start(_type, _args) do
    children = [
      {Absolutify, %State{}}
    ]

    opts = [strategy: :one_for_one, name: Absolutify.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
