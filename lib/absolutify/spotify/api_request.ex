defmodule Absolutify.Spotify.ApiRequest do
  alias Absolutify.Spotify.Credentials

  @url "https://api.spotify.com/v1"

  def get(url, %Credentials{} = credentials) do
    HTTPoison.get(@url <> url, headers(credentials))
    |> handle_response()
  end

  def post(url, %Credentials{} = credentials) do
    HTTPoison.post(@url <> url, "", headers(credentials))
    |> handle_response()
  end

  defp headers(%Credentials{access_token: access_token}) do
    [
      "Content-Type": "application/json",
      Authorization: "Bearer #{access_token}"
    ]
  end

  defp handle_response(%HTTPoison.Response{body: response, status_code: code})
       when code in 200..201 do
    response
    |> Poison.decode()
  end

  defp handle_response(%HTTPoison.Response{status_code: code}) when code >= 400 do
    {:error, "It was not possible to connect to the Spotify API. Authentication problem maybe?"}
  end
end
