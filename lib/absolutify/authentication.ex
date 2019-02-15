defmodule Absolutify.Authentication do
  alias Absolutify.{AuthenticationRequest, Credentials}

  def auth(%Credentials{} = credentials \\ %Credentials{}) do
    case Credentials.is_expired?(credentials) do
      true -> re_auth(credentials)
      false -> {:ok, credentials}
    end
  end

  defp re_auth(%Credentials{} = credentials) do
    AuthenticationRequest.post(body(credentials))
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
    |> Poison.decode()
    |> auth_error()
  end

  defp auth_error({:ok, %{"error_description" => error_description}}),
    do: {:auth_error, error_description}

  defp auth_error(_error), do: {:auth_error, "Could not authenticate"}
end
