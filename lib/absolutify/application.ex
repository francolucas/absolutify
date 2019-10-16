defmodule Absolutify.Application do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Absolutify.WebServer.Router,
        options: [port: Application.get_env(:absolutify, :port)]
      ),
      {Absolutify.Dynamic, name: Absolutify.Dynamic}
    ]

    log_address()

    opts = [strategy: :one_for_one, name: Absolutify.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp log_address do
    app_url = Application.get_env(:absolutify, :url)
    app_port = Application.get_env(:absolutify, :port)
    IO.puts("Please, access the app at #{app_url}:#{app_port} and follow the instructions")
  end
end
