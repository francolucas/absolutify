defmodule Absolutify.Spotify.Playlist do
  alias Absolutify.Track
  alias Absolutify.Spotify.{ApiRequest, Credentials, Responder}

  @spec add_track(Credentials.t(), Track.t()) :: {:ok, Track.t()} | {:error, any}
  def add_track(_credentials, %Track{spotify_uri: nil}),
    do: {:error, "The track has no :spotify_uri"}

  def add_track(
        %Credentials{} = credentials,
        %Track{spotify_uri: spotify_uri} = track
      ) do
    with {:ok, response} <- do_request(credentials, spotify_uri),
         {:ok, _body} <- Responder.handle_response(response) do
      {:ok, track}
    else
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
