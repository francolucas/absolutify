defmodule Absolutify.Spotify.SearchTest do
  use ExUnit.Case

  import Mock

  alias Absolutify.Mocks.Data
  alias Absolutify.RequestMock
  alias Absolutify.Spotify.{ApiRequest, Search}

  describe "Search.track/2" do
    test "returns the track with the Spotify uri" do
      with_mock ApiRequest,
        get: fn _url, _credentials -> RequestMock.get(:search_track_success) end do
        {:ok, track_with_spotify_uri} = Search.track(Data.credentials(), Data.track())
        assert "spotify:track:6u0x5ad9ewHvs3z6u9Oe3c" == track_with_spotify_uri.spotify_uri
      end
    end

    test "returns an expected error when Spotify can not find the track" do
      with_mock ApiRequest,
        get: fn _url, _credentials -> RequestMock.get(:track_not_found) end do
        assert {:error, "Spotify could not find the track."} ==
                 Search.track(Data.credentials(), Data.track())
      end
    end
  end
end
