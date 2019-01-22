defmodule Absolutify.Track do
  alias Absolutify.Track

  defstruct [:artist, :title, :played_at]

  def new(played_at, artist, title) when is_integer(played_at) do
    DateTime.from_unix!(played_at, :second)
    |> new(artist, title)
  end

  def new(%DateTime{} = played_at, artist, title) do
    %Track{artist: artist, title: title, played_at: played_at}
  end
end
