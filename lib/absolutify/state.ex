defmodule Absolutify.State do
  alias Absolutify.State

  defstruct [:credentials, :latest_track_played_at]

  @type t :: %State{
          credentials: Absolutify.Spotify.Credentials.t(),
          latest_track_played_at: DateTime.t()
        }
end
