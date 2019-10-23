defmodule Absolutify.Logger do
  @spec start_message :: :ok
  def start_message do
    app_url = Application.get_env(:absolutify, :url)
    app_port = Application.get_env(:absolutify, :port)

    IO.puts([IO.ANSI.clear(), IO.ANSI.home()])

    IO.puts(["You can now access ", IO.ANSI.bright(), color(:blue, "Absolutify"), IO.ANSI.reset()])

    IO.puts([])
    IO.puts(["Address: #{app_url}:", IO.ANSI.bright(), "#{app_port}", IO.ANSI.reset()])
    IO.puts([])
    IO.puts([])
  end

  defp color(:blue, text) do
    IO.ANSI.color(039) <> text
  end
end
