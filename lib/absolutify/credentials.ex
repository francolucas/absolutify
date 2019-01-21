defmodule Absolutify.Credentials do
  alias Absolutify.Credentials

  defstruct [:access_token, :refresh_token, :valid_until]

  def new(%{"access_token" => access_token} = response, %Credentials{} = credentials) do
    Map.put(credentials, :access_token, access_token)
    |> refresh_token(response)
    |> valid_until(response)
  end

  def is_expired?(%Credentials{valid_until: nil}), do: true
  def is_expired?(%Credentials{valid_until: valid_until}) do
    :os.system_time(:seconds) > valid_until
  end

  defp refresh_token(%Credentials{} = credentials, %{"refresh_token" => refresh_token}) do
    Map.put(credentials, :refresh_token, refresh_token)
  end

  defp refresh_token(credentials, _response), do: credentials

  defp valid_until(%Credentials{} = credentials, %{"expires_in" => expires_in}) do
    valid_until = :os.system_time(:seconds) + expires_in - 60
    Map.put(credentials, :valid_until, valid_until)
  end

  defp valid_until(credentials, _response), do: credentials
end
