defmodule Absolutify.Logger do
  require Logger

  @colors %{
    :blue => IO.ANSI.color(039),
    :green => IO.ANSI.color(035)
  }

  @spec start_message :: :ok
  def start_message do
    app_url = Application.get_env(:absolutify, :url)
    app_port = Application.get_env(:absolutify, :port)

    IO.puts([IO.ANSI.clear(), IO.ANSI.home()])

    IO.puts([
      "You can now access ",
      IO.ANSI.bright(),
      @colors[:blue],
      "Absolutify",
      IO.ANSI.reset()
    ])

    IO.puts([])
    IO.puts(["Address: #{app_url}:", IO.ANSI.bright(), "#{app_port}", IO.ANSI.reset()])
    IO.puts([])
    IO.puts([])
  end

  @spec info(any, :blue | :green) :: :ok | {:error, any}
  def info(msg, color \\ :green) do
    Logger.info(msg, ansi_color: @colors[color])
  end

  @spec error(any) :: :ok | {:error, any}
  def error(msg) do
    Logger.error(msg)
  end
end
