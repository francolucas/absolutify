defmodule Absolutify.Track do
  alias Absolutify.Track

  defstruct [:artist, :title, :played_at, :spotify_uri]

  @type t :: %Track{
          artist: String.t(),
          title: String.t(),
          played_at: DateTime.t(),
          spotify_uri: String.t() | nil
        }

  @spec new(String.t() | DateTime.t(), String.t(), String.t()) :: Track.t()
  def new(played_at, artist, title) when is_binary(played_at) do
    {:ok, datetime, 0} =
      (played_at <> "Z")
      |> DateTime.from_iso8601()

    new(datetime, artist, title)
  end

  def new(%DateTime{} = played_at, artist, title) do
    %Track{artist: String.trim(artist), title: String.trim(title), played_at: played_at}
  end

  @spec add_spotify_uri(Track.t(), String.t()) :: Track.t()
  def add_spotify_uri(%Track{} = track, spotify_uri) do
    %Track{track | spotify_uri: spotify_uri}
  end
end
