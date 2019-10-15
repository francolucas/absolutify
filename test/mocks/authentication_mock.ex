defmodule Absolutify.AuthenticationMock do
  alias Absolutify.Mocks.Data
  alias Absolutify.Spotify.Credentials

  @spec auth(:valid_credentials | :invalid_credentials) :: {:ok, Credentials.t()} | {:error, any}
  def auth(:valid_credentials) do
    {:ok, Data.credentials()}
  end

  def auth(:invalid_credentials) do
    {:error, "Invalid code"}
  end
end
