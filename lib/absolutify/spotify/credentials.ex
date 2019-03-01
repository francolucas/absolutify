defmodule Absolutify.Spotify.Credentials do
  alias Absolutify.Spotify.Credentials

  defstruct [:access_token, :refresh_token, :valid_until]

  def new(%{"access_token" => access_token} = response, %Credentials{} = credentials) do
    new_credentials =
      %Credentials{credentials | access_token: access_token}
      |> refresh_token(response)
      |> valid_until(response)

    {:ok, new_credentials}
  end

  def is_expired?(%Credentials{valid_until: nil}), do: true

  def is_expired?(%Credentials{valid_until: valid_until}) do
    now = :os.system_time(:seconds) |> DateTime.from_unix!(:second)
    now > valid_until
  end

  defp refresh_token(credentials, %{"refresh_token" => refresh_token}) do
    %Credentials{credentials | refresh_token: refresh_token}
  end

  defp refresh_token(credentials, _response), do: credentials

  defp valid_until(credentials, %{"expires_in" => expires_in}) do
    valid_until =
      (:os.system_time(:seconds) + expires_in - 60)
      |> DateTime.from_unix!(:second)

    %Credentials{credentials | valid_until: valid_until}
  end
end
