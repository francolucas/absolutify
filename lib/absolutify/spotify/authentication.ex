defmodule Absolutify.Spotify.Authentication do
  alias Absolutify.Logger
  alias Absolutify.Spotify.{AuthenticationRequest, Credentials, Responder}

  @spec authorize_url() :: String.t()
  def authorize_url do
    client_id = Application.get_env(:absolutify, :client_id)
    callback_url = callback_url()

    "https://accounts.spotify.com/en/authorize?response_type=code" <>
      "&client_id=#{client_id}" <>
      "&redirect_uri=#{callback_url}" <>
      "&scope=playlist-read-private playlist-modify-private playlist-modify-public"
  end

  @spec auth(Credentials.t()) :: {:ok, Credentials.t()} | {:error, any}
  def auth(%Credentials{} = credentials \\ %Credentials{}) do
    case Credentials.is_expired?(credentials) do
      true -> re_auth(credentials)
      false -> {:ok, credentials}
    end
  end

  defp callback_url do
    app_url = Application.get_env(:absolutify, :url)
    app_port = Application.get_env(:absolutify, :port)

    "#{app_url}:#{app_port}/callback" |> URI.encode_www_form()
  end

  defp re_auth(%Credentials{} = credentials) do
    Logger.info("Authenticating the user in Spotify")

    with {:ok, response} <- AuthenticationRequest.post(body(credentials)),
         {:ok, body} <- Responder.handle_response(response) do
      Credentials.new(body, credentials)
    else
      error -> error
    end
  end

  defp body(%Credentials{refresh_token: nil, code: code}) do
    callback_url = callback_url()

    "grant_type=authorization_code&code=#{code}&redirect_uri=#{callback_url}"
  end

  defp body(%Credentials{refresh_token: token}) do
    "grant_type=refresh_token&refresh_token=#{token}"
  end
end
