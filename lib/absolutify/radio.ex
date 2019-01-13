defmodule Absolutify.Radio do
  @url "https://absoluteradio.co.uk/_ajax/recently-played.php"
  @headers ["Content-Type": "application/x-www-form-urlencoded"]

  def last_track() do
    latest_tracks()
    |> hd()
  end

  def latest_tracks() do
    body = request_body()

    HTTPoison.post(@url, body, @headers)
    |> handle_response()
  end

  defp request_body do
    "lastTime=#{System.system_time(:second)}&serviceID=1&mode=more&searchTerm="
  end

  defp handle_response({:ok, %HTTPoison.Response{body: response, status_code: 200}})
       when is_binary(response) do
    response
    |> Poison.decode()
    |> build_tracks()
  end

  defp build_tracks({:ok, %{"events" => tracks}}) when is_list(tracks) do
    Enum.map(tracks, &build_track/1)
  end

  defp build_track(%{
         "ArtistName" => artist,
         "AllTrackTitle" => track,
         "EventTimestamp" => timestamp
       }) do
    %{
      artist_name: artist,
      track_title: track,
      event_time: timestamp
    }
  end
end
