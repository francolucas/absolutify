defmodule Absolutify do
  use GenServer
  require Logger

  alias Absolutify.{Authentication, Credentials, Radio, Spotify, State, Track}

  @job_interval 60_000

  def start_link(_state) do
    state = %State{credentials: %Credentials{}}
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    {:ok, do_job(state)}
  end

  def handle_info(:job, state) do
    {:noreply, do_job(state)}
  end

  def handle_info({:stop, message}, state) do
    Logger.error("Exiting: #{inspect(message)}")
    {:stop, :normal, state}
  end

  defp do_job(state) do
    new_state =
      with {:ok, credentials} <- Authentication.auth(state.credentials),
           {:ok, track} <- Radio.last_track(),
           {:ok, track} <- new_track?(state, track),
           {:ok, track} <- Spotify.search_track(credentials, track) do
        Logger.info("Track: #{inspect(track)}")
        %State{credentials: credentials, last_track_played_at: track.played_at}
      else
        error ->
          handle_error(error)
          state
      end

    schedule_next_job()
    new_state
  end

  defp new_track?(
         %State{last_track_played_at: last_track_played_at},
         %Track{played_at: played_at} = track
       ) do
    case last_track_played_at != played_at do
      true -> {:ok, track}
      false -> {:error, :tracked}
    end
  end

  defp handle_error({:error, :tracked}), do: nil
  defp handle_error({:auth_error, message}), do: send(self(), {:stop, message})
  defp handle_error(error), do: Logger.error("Error: #{inspect(error)}")

  defp schedule_next_job(), do: Process.send_after(self(), :job, @job_interval)
end
