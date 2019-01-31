defmodule Absolutify.Track do
  alias Absolutify.Track

  defstruct [:artist, :title, :played_at, :spotify_uri]

  def new(played_at, artist, title) when is_integer(played_at) do
    DateTime.from_unix!(played_at, :second)
    |> new(artist, title)
  end

  def new(%DateTime{} = played_at, artist, title) do
    %Track{artist: String.trim(artist), title: String.trim(title), played_at: played_at}
  end

  def add_spotify_uri(%Track{} = track, spotify_uri) do
    %Track{track | spotify_uri: spotify_uri}
  end
end
