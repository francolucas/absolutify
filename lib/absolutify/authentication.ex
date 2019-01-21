defmodule Absolutify.Authentication do
  alias Absolutify.Credentials

  @url "https://accounts.spotify.com/api/token"

  def auth(%Credentials{} = credentials) do
    HTTPoison.post(@url, body(credentials), headers())
    |> handle_response(credentials)
  end

  defp body(%Credentials{refresh_token: nil}) do
    code = Application.get_env(:absolutify, :code)
    callback_url = Application.get_env(:absolutify, :callback_url) |> URI.encode_www_form()

    "grant_type=authorization_code&code=#{code}&redirect_uri=#{callback_url}"
  end

  defp body(%Credentials{refresh_token: token}) do
    "grant_type=refresh_token&refresh_token=#{token}"
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

  defp handle_response({:ok, %HTTPoison.Response{body: response, status_code: 200}}, credentials) do
    response
    |> Poison.decode!()
    |> Credentials.new(credentials)
  end

  defp handle_response(
         {:ok, %HTTPoison.Response{body: response, status_code: status_code}},
         _credentials
       )
       when status_code >= 400 do
    response
    |> Poison.decode!()
    |> auth_error()
  end

  defp auth_error(%{"error_description" => error_description}) do
    raise error_description
  end
end
