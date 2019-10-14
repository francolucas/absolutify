defmodule Absolutify.Application do
  use Application

  require Logger

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Absolutify.WebServer.Router,
        options: [port: Application.get_env(:absolutify, :port)]
      ),
      {Absolutify.Dynamic, name: Absolutify.Dynamic}
    ]

    opts = [strategy: :one_for_one, name: Absolutify.Supervisor]

    case Supervisor.start_link(children, opts) do
      {:ok, pid} ->
        log_address()
        {:ok, pid}

      error ->
        error
    end
  end

  defp log_address do
    app_url = Application.get_env(:absolutify, :url)
    app_port = Application.get_env(:absolutify, :port)
    Logger.info("Please, access the app at #{app_url}:#{app_port} and follow the instructions")
  end
end
