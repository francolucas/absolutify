defmodule Absolutify.Radio.Request do
  @url "https://listenapi.planetradio.co.uk/api9/events/abr/now/48"

  @spec get() :: {:ok | :error, any}
  def get do
    HTTPoison.get(@url)
  end
end
