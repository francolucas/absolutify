defmodule Absolutify.AuthenticationRequest do
  @url "https://accounts.spotify.com/api/token"

  def post(body) when is_binary(body) do
    HTTPoison.post(@url, body, headers())
  end

  defp headers() do
    [
      "Content-Type": "application/x-www-form-urlencoded",
      Authorization: "Basic #{auth_token()}"
    ]
  end

  defp auth_token() do
    client_id = Application.get_env(:absolutify, :client_id)
    secret_key = Application.get_env(:absolutify, :secret_key)

    :base64.encode("#{client_id}:#{secret_key}")
  end
end
