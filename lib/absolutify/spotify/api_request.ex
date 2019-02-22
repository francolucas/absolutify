defmodule Absolutify.Spotify.ApiRequest do
  alias Absolutify.Spotify.Credentials

  @url "https://api.spotify.com/v1"

  def get(url, %Credentials{} = credentials) do
    HTTPoison.get(@url <> url, headers(credentials))
  end

  def post(url, %Credentials{} = credentials) do
    HTTPoison.post(@url <> url, "", headers(credentials))
  end

  defp headers(%Credentials{access_token: access_token}) do
    [
      "Content-Type": "application/json",
      Authorization: "Bearer #{access_token}"
    ]
  end
end
