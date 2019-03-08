defmodule Absolutify.Spotify.SearchTest do
  use ExUnit.Case

  import Mock

  alias Absolutify.RequestMock
  alias Absolutify.Spotify.{ApiRequest, Credentials, Search}
  alias Absolutify.Track

  setup_all do
    expires_at = (:os.system_time(:seconds) - 10) |> DateTime.from_unix!(:second)

    credentials = %Credentials{
      access_token: "a_valid_access_token",
      refresh_token: "a_valid_refresh_token",
      valid_until: expires_at
    }

    track = Track.new(1_552_058_700, "The Strokes", "Under Cover of Darkness")

    %{credentials: credentials, track: track}
  end

  describe "Search.track/2" do
    test "returns the track with the Spotify uri", context do
      with_mock ApiRequest,
        get: fn _url, _credentials -> RequestMock.get(:search_track_success) end do
        {:ok, track_with_spotify_uri} = Search.track(context.credentials, context.track)
        assert "spotify:track:6u0x5ad9ewHvs3z6u9Oe3c" == track_with_spotify_uri.spotify_uri
      end
    end

    test "returns an expected error when Spotify can not find the track", context do
      with_mock ApiRequest,
        get: fn _url, _credentials -> RequestMock.get(:track_not_found) end do
        assert {:error, "Spotify could not find the track."} ==
                 Search.track(context.credentials, context.track)
      end
    end
  end
end
