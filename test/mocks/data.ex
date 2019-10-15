defmodule Absolutify.Mocks.Data do
  alias Absolutify.Spotify.Credentials
  alias Absolutify.Track

  @spec track :: Track.t()
  def track do
    Track.new(1_552_058_700, "The Strokes", "Under Cover of Darkness")
  end

  @spec credentials :: Credentials.t()
  def credentials do
    {:ok, credentials} =
      %{
        "access_token" => "a_valid_access_token",
        "refresh_token" => "a_valid_refresh_token",
        "expires_in" => 3600
      }
      |> Credentials.new(%Credentials{})

    credentials
  end
end
