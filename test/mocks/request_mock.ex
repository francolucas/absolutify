defmodule HTTPoison.Response do
  defstruct body: nil, headers: nil, status_code: nil
end

defmodule HTTPoison.Error do
  defstruct id: nil, reason: nil
end

defmodule Absolutify.RequestMock do
  # 20X responses
  @spec get(
          :search_track_success
          | :track_not_found
          | :empty_response_success
          | :latest_tracks_invalid_list
          | :latest_tracks_success
          | :unexpected_error
        ) :: {:ok, HTTPoison.Response.t()}
  def get(:search_track_success) do
    {:ok, search_track_success_response()}
  end

  def get(:track_not_found) do
    {:ok, track_not_found_response()}
  end

  def get(:latest_tracks_success) do
    {:ok, latest_tracks_response()}
  end

  def get(:latest_tracks_invalid_list) do
    {:ok, latest_tracks_invalid_list_response()}
  end

  def get(:empty_response_success) do
    {:ok, empty_response()}
  end

  def get(:unexpected_error) do
    {:ok, failed_response_without_description()}
  end

  @spec post(
          :added_to_playlist_success
          | :auth_invalid_code
          | :auth_success
          | :refresh_token_success
          | :unexpected_error
        ) :: {:ok, HTTPoison.Response.t()}
  def post(:auth_success) do
    {:ok, auth_success_response()}
  end

  def post(:refresh_token_success) do
    {:ok, refresh_token_success_response()}
  end

  def post(:added_to_playlist_success) do
    {:ok, added_to_playlist_response()}
  end

  # 4XX responses
  def post(:auth_invalid_code) do
    {:ok, auth_invalid_code_response()}
  end

  def post(:unexpected_error) do
    {:ok, failed_response_without_description()}
  end

  defp search_track_success_response do
    %HTTPoison.Response{
      body: "{\"tracks\":{\"href\":\"https://api.spotify.com/v1/search?query=Query&type=track\",
        \"items\":[{\"album\":{},\"artists\":[],\"available_markets\":[],\"disc_number\":1,
        \"duration_ms\":235546,\"explicit\":false,\"external_ids\":{\"isrc\":\"USRC11100031\"},
        \"external_urls\":{\"spotify\":\"https://open.spotify.com/track/6u0x5ad9ewHvs3z6u9Oe3c\"},
        \"href\":\"https://api.spotify.com/v1/tracks/6u0x5ad9ewHvs3z6u9Oe3c\",
        \"id\":\"6u0x5ad9ewHvs3z6u9Oe3c\",\"is_local\":false,\"name\":\"Under Cover of Darkness\",
        \"popularity\":68,\"preview_url\":\"\",\"track_number\":2,\"type\":\"track\",
        \"uri\":\"spotify:track:6u0x5ad9ewHvs3z6u9Oe3c\"},{\"album\":{},\"artists\":[],
        \"available_markets\":[],\"disc_number\":1,\"duration_ms\":235171,\"explicit\":false,
        \"external_ids\":{\"isrc\":\"USRC11100031\"},\"external_urls\":{
        \"spotify\":\"https://open.spotify.com/track/3sqW6O1PtfBnmJpHRitB5N\"},
        \"href\":\"https://api.spotify.com/v1/tracks/3sqW6O1PtfBnmJpHRitB5N\",\"id\":\"3sqW6O1PtfBnmJpHRitB5N\",
        \"is_local\":false,\"name\":\"Under Cover of Darkness\",\"popularity\":38,\"preview_url\":\"\",
        \"track_number\":1,\"type\":\"track\",\"uri\":\"spotify:track:3sqW6O1PtfBnmJpHRitB5N\"},{
        \"album\":{},\"artists\":[],\"available_markets\":[],\"disc_number\":4,\"duration_ms\":235546,
        \"explicit\":false,\"external_ids\":{\"isrc\":\"USRC11100031\"},\"external_urls\":{
        \"spotify\":\"https://open.spotify.com/track/5zwf83kXfabDCOLVC2qHaM\"},
        \"href\":\"https://api.spotify.com/v1/tracks/5zwf83kXfabDCOLVC2qHaM\",\"id\":\"5zwf83kXfabDCOLVC2qHaM\",
        \"is_local\":false,\"name\":\"Under Cover of Darkness\",\"popularity\":28,\"preview_url\":\"\",
        \"track_number\":2,\"type\":\"track\",\"uri\":\"spotify:track:5zwf83kXfabDCOLVC2qHaM\"}],\"limit\":3,
        \"next\":\"https://api.spotify.com/v1/search?query=Query&type=track&offset=3\",
        \"offset\":0,\"previous\":null,\"total\":34}  }",
      headers: [],
      status_code: 200
    }
  end

  defp track_not_found_response do
    %HTTPoison.Response{
      body: "{\"tracks\":{
        \"href\":\"https://api.spotify.com/v1/search?query=Query&type=track&offset=0&limit=20\",
        \"items\":[],\"limit\":20,\"next\":null,\"offset\":0,\"previous\":null,\"total\":0}}",
      headers: [],
      status_code: 200
    }
  end

  defp auth_success_response do
    %HTTPoison.Response{
      body: "{\"access_token\":\"a_valid_access_token\",\"token_type\":\"Bearer\",
        \"expires_in\":3600,\"refresh_token\":\"a_valid_refresh_token\",
        \"scope\":\"playlist-read-private playlist-modify-private playlist-modify-public\"}",
      headers: [],
      status_code: 200
    }
  end

  defp refresh_token_success_response do
    %HTTPoison.Response{
      body: "{\"access_token\":\"a_valid_access_token\",\"token_type\":\"Bearer\",
        \"expires_in\":3600,
        \"scope\":\"playlist-read-private playlist-modify-private playlist-modify-public\"}",
      headers: [],
      status_code: 200
    }
  end

  defp latest_tracks_response do
    %HTTPoison.Response{
      body:
        "[{\"nowPlayingTrackId\":3747,\"nowPlayingTrack\":\"Fluorescent Adolescent\",
        \"nowPlayingArtist\":\"Arctic Monkeys\",
        \"nowPlayingImage\":\"https://assets.planetradio.co.uk/artist/1-1/320x320/3959.jpg?ver=1465084749\",
        \"nowPlayingSmallImage\":\"https://assets.planetradio.co.uk/artist/1-1/160x160/3959.jpg?ver=1465084749\",
        \"nowPlayingTime\":\"2019-10-24 06:27:48\",\"nowPlayingDuration\":165,\"nowPlayingAppleMusicUrl\":
        \"https://geo.itunes.apple.com/dk/album/251126923?i=251126957\"},{\"nowPlayingTrackId\":2075,
        \"nowPlayingTrack\":\"Children Of The Revolution\",\"nowPlayingArtist\":\"T Rex\",
        \"nowPlayingImage\":\"https://assets.planetradio.co.uk/track/2075.jpg?ver=1464804454\",
        \"nowPlayingSmallImage\":\"https://assets.planetradio.co.uk/track/160x160/2075.jpg?ver=1464804454\",
        \"nowPlayingTime\":\"2019-10-24 06:23:16\",\"nowPlayingDuration\":137,
        \"nowPlayingAppleMusicUrl\":\"https://geo.itunes.apple.com/dk/album/262705985?i=262706295\"},{
        \"nowPlayingTrackId\":157093,\"nowPlayingTrack\":\"Bust This Town\",
        \"nowPlayingArtist\":\"Stereophonics\",
        \"nowPlayingImage\":\"https://assets.planetradio.co.uk/artist/1-1/320x320/117.jpg?ver=1465083215\",
        \"nowPlayingSmallImage\":\"https://assets.planetradio.co.uk/artist/1-1/160x160/117.jpg?ver=1465083215\",
        \"nowPlayingTime\":\"2019-10-24 06:14:38\",\"nowPlayingDuration\":240,
        \"nowPlayingAppleMusicUrl\":\"https://geo.itunes.apple.com/dk/album/1475933493?i=1475933511\"},{
        \"nowPlayingTrackId\":15122,\"nowPlayingTrack\":\"Live And Let Die\",
        \"nowPlayingArtist\":\"Guns N Roses\",
        \"nowPlayingImage\":\"https://assets.planetradio.co.uk/artist/1-1/320x320/664.jpg?ver=1465083551\",
        \"nowPlayingSmallImage\":\"https://assets.planetradio.co.uk/artist/1-1/160x160/664.jpg?ver=1465083551\",
        \"nowPlayingTime\":\"2019-10-24 06:08:58\",\"nowPlayingDuration\":180,
        \"nowPlayingAppleMusicUrl\":\"https://geo.itunes.apple.com/dk/album/68192941?i=68193108\"}]",
      headers: [],
      status_code: 200
    }
  end

  defp latest_tracks_invalid_list_response do
    %HTTPoison.Response{
      body:
        "[{\"nowPlayingTrackId\":3747,\"nowPlayingTrack\":\"Fluorescent Adolescent\",
        \"nowPlayingImage\":\"https://assets.planetradio.co.uk/artist/1-1/320x320/3959.jpg?ver=1465084749\",
        \"nowPlayingSmallImage\":\"https://assets.planetradio.co.uk/artist/1-1/160x160/3959.jpg?ver=1465084749\",
        \"nowPlayingTime\":\"2019-10-24 06:27:48\",\"nowPlayingDuration\":165,\"nowPlayingAppleMusicUrl\":
        \"https://geo.itunes.apple.com/dk/album/251126923?i=251126957\"},{\"nowPlayingTrackId\":2075,
        \"nowPlayingArtist\":\"T Rex\",
        \"nowPlayingImage\":\"https://assets.planetradio.co.uk/track/2075.jpg?ver=1464804454\",
        \"nowPlayingSmallImage\":\"https://assets.planetradio.co.uk/track/160x160/2075.jpg?ver=1464804454\",
        \"nowPlayingTime\":\"2019-10-24 06:23:16\",\"nowPlayingDuration\":137,
        \"nowPlayingAppleMusicUrl\":\"https://geo.itunes.apple.com/dk/album/262705985?i=262706295\"},{
        \"nowPlayingTrackId\":157093,\"nowPlayingTrack\":\"Bust This Town\",
        \"nowPlayingArtist\":\"Stereophonics\",
        \"nowPlayingImage\":\"https://assets.planetradio.co.uk/artist/1-1/320x320/117.jpg?ver=1465083215\",
        \"nowPlayingSmallImage\":\"https://assets.planetradio.co.uk/artist/1-1/160x160/117.jpg?ver=1465083215\",
        \"nowPlayingDuration\":240,
        \"nowPlayingAppleMusicUrl\":\"https://geo.itunes.apple.com/dk/album/1475933493?i=1475933511\"}]",
      headers: [],
      status_code: 200
    }
  end

  defp empty_response do
    %HTTPoison.Response{
      body: "",
      headers: [],
      status_code: 200
    }
  end

  defp added_to_playlist_response do
    %HTTPoison.Response{
      body: "{\"snapshot_id\":\"jDPaq5bidakN8ukz1hOd\"}",
      headers: [],
      status_code: 201
    }
  end

  defp auth_invalid_code_response do
    %HTTPoison.Response{
      body: "{\"error\":\"invalid_grant\",\"error_description\":\"Invalid authorization code\"}",
      headers: [],
      status_code: 400
    }
  end

  defp failed_response_without_description do
    %HTTPoison.Response{
      body: "A response with some error",
      headers: [],
      status_code: 403
    }
  end
end
