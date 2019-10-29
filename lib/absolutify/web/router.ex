defmodule Absolutify.Web.Router do
  use Plug.Router
  alias Absolutify.Web.Controller
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
    Controller.action(:notfound, conn)
  end
end
