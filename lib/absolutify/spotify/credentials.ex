defmodule Absolutify.Spotify.Credentials do
  alias Absolutify.Spotify.Credentials

  defstruct [:access_token, :refresh_token, :valid_until]

  @type t :: %Credentials{
          access_token: String.t(),
          refresh_token: String.t(),
          valid_until: DateTime.t()
        }

  @type token :: %{
          access_token: String.t(),
          token_type: String.t(),
          scope: String.t(),
          expires_in: integer,
          refresh_token: String.t()
        }

  @spec new(Credentials.token(), Credentials.t()) :: {:ok, Credentials.t()}
  def new(%{"access_token" => access_token} = response, %Credentials{} = credentials) do
    new_credentials =
      %Credentials{credentials | access_token: access_token}
      |> refresh_token(response)
      |> valid_until(response)

    {:ok, new_credentials}
  end

  @spec is_expired?(Credentials.t()) :: boolean
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
