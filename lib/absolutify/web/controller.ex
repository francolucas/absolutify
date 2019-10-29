defmodule Absolutify.Web.Controller do
  import Plug.Conn
  alias Absolutify.Dynamic
  alias Absolutify.Spotify.{Authentication, Credentials}
  alias Plug.Conn.Query

  @templates %{
    :index => "lib/absolutify/web/templates/index.html.eex",
    :callback => "lib/absolutify/web/templates/callback.html.eex",
    :error => "lib/absolutify/web/templates/error.html.eex"
  }

  @spec action(:callback | :connect | :home | :notfound, Plug.Conn.t()) :: Plug.Conn.t()
  def action(:home, conn) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, render(:index))
  end

  def action(:connect, conn) do
    conn
    |> resp(302, "")
    |> put_resp_header("location", Authentication.authorize_url())
  end

  def action(:callback, conn) do
    {code, response} =
      with {:ok, code} <- extract_code(conn),
           {:ok, credentials} <- Authentication.auth(%Credentials{code: code}),
           {:ok, _pid} <- Dynamic.start_crawler(credentials) do
        {200, render(:callback)}
      else
        _error -> {400, render(:error, error: "It was not possible to connect to Spotify.")}
      end

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(code, response)
  end

  def action(:notfound, conn) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(404, render(:error, error: "Oops... Nothing here :("))
  end

  defp extract_code(conn) do
    case Query.decode(conn.query_string) do
      %{"code" => code} -> {:ok, code}
      _ -> :nocode
    end
  end

  defp render(page, bindings \\ []) do
    page = EEx.eval_file(@templates[page], bindings)

    EEx.eval_file("lib/absolutify/web/templates/layout.html.eex", page: page)
  end
end
