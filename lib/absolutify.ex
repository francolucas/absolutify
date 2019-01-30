defmodule Absolutify do
  use GenServer

  alias Absolutify.{Radio, State, Track}

  @job_interval 60_000

  def start_link(state \\ %State{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(%State{} = state) do
    new_state = do_job(state)
    {:ok, new_state}
  end

  def handle_info(:job, %State{} = state) do
    new_state = do_job(state)
    {:noreply, new_state}
  end

  defp do_job(%State{} = state) do
    new_state =
      with {:ok, track} <- Radio.last_track(),
           true <- new_track?(state, track) do
        Map.put(state, :last_track_played_at, track.played_at)
      else
        _error -> state
      end

    schedule_next_job()
    new_state
  end

  defp new_track?(%State{last_track_played_at: last_track_played_at}, %Track{played_at: played_at}) do
    case last_track_played_at != played_at do
      true -> true
      false -> {:error, "Track already tracked"}
    end
  end

  defp schedule_next_job(), do: Process.send_after(self(), :job, @job_interval)
end
