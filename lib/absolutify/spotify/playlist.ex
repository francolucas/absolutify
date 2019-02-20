defmodule Absolutify.Spotify.Playlist do
  alias Absolutify.Track
  alias Absolutify.Spotify.{ApiRequest, Credentials}

  def add_track(_credentials, %Track{spotify_uri: nil}),
    do: {:error, "The track has no :spotify_uri"}

  def add_track(
        %Credentials{} = credentials,
        %Track{spotify_uri: spotify_uri} = track
      ) do
    case do_request(credentials, spotify_uri) do
      {:ok, _response} -> {:ok, track}
      error -> error
    end
  end

  defp do_request(credentials, spotify_uri) do
    spotify_uri
    |> url()
    |> ApiRequest.post(credentials)
  end

  defp url(spotify_uri) do
    playlist_id = Application.get_env(:absolutify, :playlist_id)

    "/playlists/#{playlist_id}/tracks?uris=#{spotify_uri}"
  end
end
