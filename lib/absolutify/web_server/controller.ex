defmodule Absolutify.WebServer.Controller do
  import Plug.Conn
  alias Absolutify.Spotify.{Authentication, Credentials}
  alias Plug.Conn.Query

  @spec render(:callback | :connect | :home, Plug.Conn.t()) :: Plug.Conn.t()
  def render(:home, conn) do
    send_resp(conn, 200, "<a href=\"/connect\">Click here</a> to connecto to Spotify")
  end

  def render(:connect, conn) do
    conn
    |> resp(:found, "")
    |> put_resp_header("Location", Authentication.authorize_url())
  end

  def render(:callback, conn) do
    with {:ok, code} <- extract_code(conn),
         {:ok, credentials} <- Authentication.auth(%Credentials{code: code}) do
      case Absolutify.Dynamic.start_crawler(credentials) do
        {:ok, _pid} ->
          send_resp(
            conn,
            200,
            "The songs are being inserted into the playlsit, you can close this page"
          )

        _error ->
          send_resp(conn, 500, "It was not possible to start the server")
      end
    else
      {:error, message} -> send_resp(conn, 400, message)
    end
  end

  defp extract_code(conn) do
    case Query.decode(conn.query_string) do
      %{"code" => code} -> {:ok, code}
      _ -> {:error, "The application was not authorized"}
    end
  end
end
