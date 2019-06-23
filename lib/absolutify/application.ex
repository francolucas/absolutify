defmodule Absolutify.Application do
  use Application

  alias Absolutify.State

  def start(_type, _args) do
    children = [
      # {Absolutify, %State{}}
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Absolutify.Endpoint,
        options: [port: 4001]
      )
    ]

    opts = [strategy: :one_for_one, name: Absolutify.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
