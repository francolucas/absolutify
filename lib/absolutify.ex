defmodule Absolutify do
  use GenServer

  alias Absolutify.Radio.AbsoluteRadio
  alias Absolutify.Spotify.{Authentication, Credentials, Playlist, Search}
  alias Absolutify.{Logger, State, Track}

  @job_interval 60_000

  def start_link(credentials) do
    GenServer.start_link(__MODULE__, credentials, name: __MODULE__)
  end

  def init(%Credentials{} = credentials) do
    state = do_job(%State{credentials: credentials})
    {:ok, state}
  end

  def handle_info(:job, state) do
    state = do_job(state)
    {:noreply, state}
  end

  def handle_info({:stop, message}, state) do
    Logger.error("Exiting: #{inspect(message)}")
    {:stop, :normal, state}
  end

  defp do_job(state) do
    new_state =
      with {:ok, credentials} <- Authentication.auth(state.credentials),
           {:ok, track} <- AbsoluteRadio.latest_track(),
           {:ok, track} <- new_track?(state, track),
           {:ok, track} <- Search.track(credentials, track),
           {:ok, track} <- Playlist.add_track(credentials, track) do
        %State{credentials: credentials, latest_track_played_at: track.played_at}
      else
        :tracked ->
          Logger.info("No new track since the last check", :blue)
          state

        error ->
          handle_error(error)
          state
      end

    schedule_next_job()
    new_state
  end

  defp new_track?(
         %State{latest_track_played_at: latest_track_played_at},
         %Track{played_at: played_at} = track
       ) do
    case latest_track_played_at != played_at do
      true -> {:ok, track}
      false -> :tracked
    end
  end

  defp handle_error(error), do: Logger.error("Error: #{inspect(error)}")

  defp schedule_next_job, do: Process.send_after(self(), :job, @job_interval)
end
