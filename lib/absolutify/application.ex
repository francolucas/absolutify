defmodule Absolutify.Application do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Absolutify.Web.Router,
        options: [port: Application.get_env(:absolutify, :port)]
      ),
      {Absolutify.Dynamic, name: Absolutify.Dynamic}
    ]

    Absolutify.Logger.start_message()

    opts = [strategy: :one_for_one, name: Absolutify.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
