defmodule Absolutify.Spotify.PlaylistTest do
  use ExUnit.Case

  import Mock

  alias Absolutify.Mocks.Data
  alias Absolutify.RequestMock
  alias Absolutify.Spotify.{ApiRequest, Playlist}
  alias Absolutify.Track

  describe "Playlist.add_track/2" do
    test "adds correctly the track in the playlist" do
      with_mock ApiRequest,
        post: fn _url, _credentials -> RequestMock.post(:added_to_playlist_success) end do
        track = Data.track() |> Track.add_spotify_uri("spotify:track:6u0x5ad9ewHvs3z6u9Oe3c")
        assert {:ok, ^track} = Playlist.add_track(Data.credentials(), track)
      end
    end

    test "returns an expected error when there is no Spotify uri in the track" do
      assert {:error, "The track has no :spotify_uri"} =
               Playlist.add_track(Data.credentials(), Data.track())
    end

    test "returns an error when it can not connect to the Spotify server" do
      with_mock ApiRequest,
        post: fn _url, _credentials -> RequestMock.post(:unexpected_error) end do
        track = Data.track() |> Track.add_spotify_uri("spotify:track:6u0x5ad9ewHvs3z6u9Oe3c")
        assert {:error, _error} = Playlist.add_track(Data.credentials(), track)
      end
    end
  end
end
