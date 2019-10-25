defmodule Absolutify.Spotify.Search do
  alias Absolutify.{Logger, Track}
  alias Absolutify.Spotify.{ApiRequest, Credentials, Responder}

  @spec track(Credentials.t(), Track.t()) :: {:ok, Track.t()} | {:error, any}
  def track(%Credentials{} = credentials, %Track{spotify_uri: nil} = track) do
    with {:ok, response} <- do_request(credentials, track),
         {:ok, body} <- Responder.handle_response(response),
         {:ok, spotify_track} <- first_result(body) do
      {:ok, Track.add_spotify_uri(track, spotify_track["uri"])}
    else
      error -> error
    end
  end

  def track(_credentials, %Track{} = track), do: {:ok, track}

  defp do_request(credentials, %Track{artist: artist, title: title})
       when not is_nil(artist) and not is_nil(title) do
    Logger.info("Searching for \"#{artist} - #{title}\" on Spotify")

    %{
      q: "#{artist} #{title}",
      type: "track"
    }
    |> url()
    |> ApiRequest.get(credentials)
  end

  defp url(params) do
    "/search?" <> URI.encode_query(params)
  end

  defp first_result(%{"tracks" => %{"items" => [spotify_track | _tail]}}),
    do: {:ok, spotify_track}

  defp first_result(_result), do: {:error, "Track not found on Spotify"}
end
