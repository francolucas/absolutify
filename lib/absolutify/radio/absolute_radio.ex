defmodule Absolutify.Radio.AbsoluteRadio do
  alias Absolutify.Radio.Request
  alias Absolutify.{Logger, Track}

  @spec latest_track() :: {:ok, Track.t()} | {:error, any}
  def latest_track do
    case latest_tracks() do
      {:ok, [track | _tracks]} -> {:ok, track}
      error -> error
    end
  end

  @spec latest_tracks() :: {:ok, [Track.t()]} | {:error, any}
  def latest_tracks do
    with {:ok, response} <- request_latest_tracks(),
         {:ok, tracks} <- handle_response(response) do
      {:ok, tracks}
    else
      error -> error
    end
  end

  defp request_latest_tracks do
    Logger.info("Requesting the latest tracks from Absolute Radio", :blue)
    Request.get()
  end

  defp handle_response(%HTTPoison.Response{body: response, status_code: 200}) do
    response
    |> Poison.decode()
    |> build_tracks()
  end

  defp handle_response(_response), do: {:error, "Could not connect to the radio server"}

  defp build_tracks({:ok, track_list}) when is_list(track_list) do
    track_list
    |> Enum.map(&build_track/1)
    |> filter_track_list
  end

  defp build_tracks(_result), do: {:error, "Not expected result format from the radio server"}

  defp build_track(%{
         "nowPlayingArtist" => artist,
         "nowPlayingTrack" => title,
         "nowPlayingTime" => played_at
       }) do
    Track.new(played_at, artist, title)
  end

  defp build_track(_event), do: nil

  defp filter_track_list(tracks) do
    track_list =
      tracks
      |> Enum.filter(&(!is_nil(&1)))

    case track_list do
      [] -> {:error, "There is no valid track in this request to the radio server"}
      _ -> {:ok, track_list}
    end
  end
end
