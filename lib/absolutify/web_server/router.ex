defmodule Absolutify.WebServer.Router do
  use Plug.Router
  alias Absolutify.WebServer.Controller
  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/" do
    Controller.action(:home, conn)
  end

  get "/connect" do
    Controller.action(:connect, conn)
  end

  get "/callback" do
    Controller.action(:callback, conn)
  end

  match _ do
    send_resp(conn, 404, "Oops... Nothing here :(")
  end
end
