defmodule Absolutify.Endpoint do
  use Plug.Router
  alias Plug.Conn.Query
  alias Absolutify.Spotify.Authentication
  alias Absolutify.Spotify.Credentials
  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/" do
    case Query.decode(conn.query_string) do
      %{"code" => code, "state" => "mystate"} -> auth(conn, code)
      _ -> invalid_request(conn)
    end
  end

  defp auth(conn, code) do
    case Authentication.auth(%Credentials{code: code}) do
      {:ok, credentials} ->
        send_resp(conn, 200, "I'm in!!")

      {_error, message} ->
        IO.inspect(message)
        send_resp(conn, 400, "I could not connect")
    end
  end

  defp invalid_request(conn) do
    send_resp(conn, 400, "oops... Invalid request :(")
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
