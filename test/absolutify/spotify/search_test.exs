defmodule Absolutify.Spotify.SearchTest do
  use ExUnit.Case

  import Mock

  alias Absolutify.RequestMock
  alias Absolutify.Spotify.{ApiRequest, Credentials, Search}
  alias Absolutify.Track

  setup do
    Application.put_env(:absolutify, :code, "dR7gOOlpu8kku7MLdbEoGoU9eoEhedgaIxuCe6WT")
    Application.put_env(:absolutify, :callback_url, "http://localhost")
    Application.put_env(:absolutify, :client_id, "ni9DdjJvLrBk79GtOTUD")
    Application.put_env(:absolutify, :secret_key, "ebBMOu14UwTpElLdxZ7f")
  end

  describe "Search.track/2" do
    test "returns the track with the Spotify uri" do
      with_mock ApiRequest,
        get: fn _url, _credentials -> RequestMock.get(:search_track_success) end do
        expires_at = (:os.system_time(:seconds) - 10) |> DateTime.from_unix!(:second)

        credentials = %Credentials{
          access_token: "a_valid_access_token",
          refresh_token: "a_valid_refresh_token",
          valid_until: expires_at
        }

        track = Track.new(1_552_058_700, "The Strokes", "Under Cover of Darkness")
        {:ok, track_with_spotify_uri} = Search.track(credentials, track)
        assert "spotify:track:6u0x5ad9ewHvs3z6u9Oe3c" == track_with_spotify_uri.spotify_uri
      end
    end
  end
end
