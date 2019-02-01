defmodule Absolutify.Spotify do
  alias Absolutify.{Credentials, Track}

  @url "https://api.spotify.com/v1"

  def search_track(%Credentials{} = credentials, %Track{spotify_uri: nil} = track) do
    with {:ok, response} <- do_search_request(credentials, track),
         {:ok, result} <- handle_response(response),
         {:ok, spotify_track} <- first_result(result) do
      {:ok, Track.add_spotify_uri(track, spotify_track["uri"])}
    else
      error -> error
    end
  end

  def search_track(_credentials, %Track{} = track), do: {:ok, track}

  def add_track_to_playlist(_credentials, %Track{spotify_uri: nil} = track), do: {:ok, track}

  def add_track_to_playlist(
        %Credentials{} = credentials,
        %Track{spotify_uri: spotify_uri} = track
      ) do
    with {:ok, response} <- do_add_to_playlist_request(credentials, spotify_uri),
         {:ok, _result} <- handle_response(response) do
      {:ok, track}
    else
      error -> error
    end
  end

  defp do_search_request(credentials, %Track{artist: artist, title: title})
       when not is_nil(artist) and not is_nil(title) do
    %{
      q: "#{artist} #{title}",
      type: "track"
    }
    |> search_url
    |> HTTPoison.get(headers(credentials))
  end

  defp search_url(params) do
    "#{@url}/search?" <> URI.encode_query(params)
  end

  defp headers(%Credentials{access_token: access_token}) do
    [
      "Content-Type": "application/json",
      Authorization: "Bearer #{access_token}"
    ]
  end

  defp handle_response(%HTTPoison.Response{body: response, status_code: code})
       when code in 200..201 do
    response
    |> Poison.decode()
  end

  defp handle_response(%HTTPoison.Response{status_code: code}) when code >= 400 do
    {:error, "It was not possible to connect to the Spotify API. Authentication problem maybe?"}
  end

  defp first_result(%{"tracks" => %{"items" => [spotify_track | _tail]}}),
    do: {:ok, spotify_track}

  defp first_result(_result), do: {:error, "Spotify could not find the track."}

  defp do_add_to_playlist_request(credentials, spotify_uri) do
    spotify_uri
    |> add_to_playlist_url()
    |> HTTPoison.post("", headers(credentials))
  end

  defp add_to_playlist_url(spotify_uri) do
    playlist_id = Application.get_env(:absolutify, :playlist_id)

    "#{@url}/playlists/#{playlist_id}/tracks?uris=#{spotify_uri}"
  end
end
