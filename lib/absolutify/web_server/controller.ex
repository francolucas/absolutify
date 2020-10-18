defmodule Absolutify.WebServer.Controller do
  import Plug.Conn
  alias Absolutify.{Dynamic, Logger}
  alias Absolutify.Spotify.{Authentication, Credentials}
  alias Plug.Conn.Query

  @spec action(:callback | :connect | :home, Plug.Conn.t()) :: Plug.Conn.t()
  def action(:home, conn) do
    send_resp(conn, 200, "<a href=\"/connect\">Click here</a> to connect to Spotify")
  end

  def action(:connect, conn) do
    conn
    |> resp(:found, "")
    |> put_resp_header("location", Authentication.authorize_url())
  end

  def action(:callback, conn) do
    with {:ok, code} <- extract_code(conn),
         {:ok, credentials} <- Authentication.auth(%Credentials{code: code}),
         {:ok, _pid} <- Dynamic.start_crawler(credentials) do
      send_resp(
        conn,
        200,
        "The application is saving the songs in the playlist. You can close this window now"
      )
    else
      error ->
        Logger.error("Error: #{inspect(error)}")
        send_resp(conn, 400, "It was not possible to connect to Spotify or start the application")
    end
  end

  defp extract_code(conn) do
    case Query.decode(conn.query_string) do
      %{"code" => code} ->
        {:ok, code}

      error ->
        Logger.error("Error: #{inspect(error)}")
        {:error, "The application was not authorized"}
    end
  end
end
