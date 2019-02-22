defmodule Absolutify.Spotify.Authentication do
  alias Absolutify.Spotify.{AuthenticationRequest, Credentials, Responder}

  def auth(%Credentials{} = credentials \\ %Credentials{}) do
    case Credentials.is_expired?(credentials) do
      true -> re_auth(credentials)
      false -> {:ok, credentials}
    end
  end

  defp re_auth(%Credentials{} = credentials) do
    with {:ok, response} <- AuthenticationRequest.post(body(credentials)),
         {:ok, body} <- Responder.handle_response(response) do
      Credentials.new(body, credentials)
    else
      error -> error
    end
  end

  defp body(%Credentials{refresh_token: nil}) do
    code = Application.get_env(:absolutify, :code)
    callback_url = Application.get_env(:absolutify, :callback_url) |> URI.encode_www_form()

    "grant_type=authorization_code&code=#{code}&redirect_uri=#{callback_url}"
  end

  defp body(%Credentials{refresh_token: token}) do
    "grant_type=refresh_token&refresh_token=#{token}"
  end
end
