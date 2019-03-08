defmodule HTTPoison.Response do
  defstruct body: nil, headers: nil, status_code: nil
end

defmodule HTTPoison.Error do
  defstruct id: nil, reason: nil
end

defmodule Absolutify.RequestMock do
  # 20X responses
  def get(:search_track_success) do
    {:ok, search_track_success_response()}
  end

  def post(:auth_success) do
    {:ok, auth_success_response()}
  end

  def post(:refresh_token_success) do
    {:ok, refresh_token_success_response()}
  end

  def post(:latest_tracks_success) do
    {:ok, latest_tracks_response()}
  end

  def post(:latest_tracks_invalid_list) do
    {:ok, latest_tracks_invalid_list_response()}
  end

  def post(:empty_response_ok) do
    {:ok, empty_response(:ok)}
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
        \"next\":\"https://api.spotify.com/v1/search?query=Query&type=track&market=BR&offset=3\",
        \"offset\":0,\"previous\":null,\"total\":34}  }",
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
      body: "{\"events\":[{\"EventTimestamp\":1551038001,\"EventStart\":\"2019-02-24 19:53\",
        \"EventPlayedDate\":\"Today\",\"EventTime\":\"7.53pm\",
        \"Url\":\"\/music\/catfish-and-the-bottlemen-12295\/kathleen-21879\/\",
        \"ArtistID\":\"12295\",\"ArtistName\":\"Catfish And The Bottlemen\",
        \"AllTrackTitle\":\"Kathleen\",\"AllTrackID\":\"21879\",
        \"iTunesTrackPreviewURL\":null,\"bonus\":0},{\"EventTimestamp\":1551037808,
        \"EventStart\":\"2019-02-24 19:50\",\"EventPlayedDate\":\"Today\",
        \"EventTime\":\"7.50pm\",\"Url\":\"\/music\/stereophonics-12\/a-thousand-trees-863\/\",
        \"ArtistID\":\"12\",\"ArtistName\":\"Stereophonics\",\"AllTrackTitle\":\"A Thousand Trees\",
        \"AllTrackID\":\"863\",\"iTunesTrackPreviewURL\":null,\"bonus\":0},{
        \"EventTimestamp\":1551037565,\"EventStart\":\"2019-02-24 19:46\",
        \"EventPlayedDate\":\"Today\",\"EventTime\":\"7.46pm\",
        \"Url\":\"\/music\/foo-fighters-2754\/the-sky-is-a-neighborhood--27953\/\",
        \"ArtistID\":\"2754\",\"ArtistName\":\"Foo Fighters\",
        \"AllTrackTitle\":\"The Sky Is A Neighborhood \",\"AllTrackID\":\"27953\",
        \"iTunesTrackPreviewURL\":null,\"bonus\":0},{\"EventTimestamp\":1551037500,
        \"EventStart\":\"2019-02-24 19:45\",\"EventPlayedDate\":\"Today\",\"EventTime\":\"7.45pm\",
        \"Url\":\"\/music\/tom-odell-11573\/another-love-18466\/\",\"ArtistID\":\"11573\",
        \"ArtistName\":\"Tom Odell\",\"AllTrackTitle\":\"Another Love\",\"AllTrackID\":\"18466\",
        \"iTunesTrackPreviewURL\":null,\"bonus\":1},{\"EventTimestamp\":1551037004,
        \"EventStart\":\"2019-02-24 19:36\",\"EventPlayedDate\":\"Today\",\"EventTime\":\"7.36pm\",
        \"Url\":\"\/music\/depeche-mode-203\/personal-jesus-12452\/\",\"ArtistID\":\"203\",
        \"ArtistName\":\"Depeche Mode\",\"AllTrackTitle\":\"Personal Jesus\",
        \"AllTrackID\":\"12452\",\"iTunesTrackPreviewURL\":null,\"bonus\":0},{
        \"EventTimestamp\":1551036793,\"EventStart\":\"2019-02-24 19:33\",
        \"EventPlayedDate\":\"Today\",\"EventTime\":\"7.33pm\",
        \"Url\":\"\/music\/the-libertines-9135\/dont-look-back-into-the-sun-559\/\",
        \"ArtistID\":\"9135\",\"ArtistName\":\"The Libertines\",
        \"AllTrackTitle\":\"Don't Look Back Into The Sun\",\"AllTrackID\":\"559\",
        \"iTunesTrackPreviewURL\":null,\"bonus\":0},{\"EventTimestamp\":1551036536,
        \"EventStart\":\"2019-02-24 19:28\",\"EventPlayedDate\":\"Today\",\"EventTime\":\"7.28pm\",
        \"Url\":\"\/music\/the-smiths-569\/there-is-a-light-that-never-goes-out-7661\/\",
        \"ArtistID\":\"569\",\"ArtistName\":\"The Smiths\",
        \"AllTrackTitle\":\"There Is A Light That Never Goes Out\",\"AllTrackID\":\"7661\",
        \"iTunesTrackPreviewURL\":null,\"bonus\":0},{\"EventTimestamp\":1551036300,
        \"EventStart\":\"2019-02-24 19:25\",\"EventPlayedDate\":\"Today\",\"EventTime\":\"7.25pm\",
        \"Url\":\"\/music\/awolnation-11274\/sail-16517\/\",\"ArtistID\":\"11274\",
        \"ArtistName\":\"AWOLNATION\",\"AllTrackTitle\":\"Sail\",\"AllTrackID\":\"16517\",
        \"iTunesTrackPreviewURL\":null,\"bonus\":1},{\"EventTimestamp\":1551035859,
        \"EventStart\":\"2019-02-24 19:17\",\"EventPlayedDate\":\"Today\",\"EventTime\":\"7.17pm\",
        \"Url\":\"\/music\/metallica-71\/enter-sandman-3568\/\",\"ArtistID\":\"71\",
        \"ArtistName\":\"Metallica\",\"AllTrackTitle\":\"Enter Sandman\",\"AllTrackID\":\"3568\",
        \"iTunesTrackPreviewURL\":null,\"bonus\":0},{\"EventTimestamp\":1551035563,
        \"EventStart\":\"2019-02-24 19:12\",\"EventPlayedDate\":\"Today\",\"EventTime\":\"7.12pm\",
        \"Url\":\"\/music\/doves-304\/pounding-47\/\",\"ArtistID\":\"304\",\"ArtistName\":\"Doves\",
        \"AllTrackTitle\":\"Pounding\",\"AllTrackID\":\"47\",\"iTunesTrackPreviewURL\":null,
        \"bonus\":0},{\"EventTimestamp\":1551035355,\"EventStart\":\"2019-02-24 19:09\",
        \"EventPlayedDate\":\"Today\",\"EventTime\":\"7.09pm\",
        \"Url\":\"\/music\/fleetwood-mac-404\/little-lies-1627\/\",\"ArtistID\":\"404\",
        \"ArtistName\":\"Fleetwood Mac\",\"AllTrackTitle\":\"Little Lies\",\"AllTrackID\":\"1627\",
        \"iTunesTrackPreviewURL\":null,\"bonus\":0},{\"EventTimestamp\":1551035111,
        \"EventStart\":\"2019-02-24 19:05\",\"EventPlayedDate\":\"Today\",\"EventTime\":\"7.05pm\",
        \"Url\":\"\/music\/aerosmith-45\/livin-on-the-edge-7230\/\",\"ArtistID\":\"45\",
        \"ArtistName\":\"Aerosmith\",\"AllTrackTitle\":\"Livin' On The Edge\",
        \"AllTrackID\":\"7230\",\"iTunesTrackPreviewURL\":null,\"bonus\":0}],\"template\":\"\"}",
      headers: [],
      status_code: 200
    }
  end

  defp latest_tracks_invalid_list_response do
    %HTTPoison.Response{
      body: "{\"events\":[{\"EventTimestamp\":1551106093,\"EventStart\":\"2019-02-25 14:48\",
        \"EventPlayedDate\":\"Today\",\"EventTime\":\"2.48pm\",
        \"Url\":\"/music/the-jam-392/thats-entertainment-303/\",\"ArtistID\":\"392\",
        \"AllTrackTitle\":\"That's Entertainment\",\"AllTrackID\":\"303\",
        \"iTunesTrackPreviewURL\":null,\"bonus\":0},{\"EventTimestamp\":1551105900,
        \"EventStart\":\"2019-02-25 14:45\",\"EventPlayedDate\":\"Today\",\"EventTime\":\"2.45pm\",
        \"Url\":\"/music/the-kinks-373/sunny-afternoon-287/\",\"ArtistID\":\"373\",
        \"ArtistName\":\"The Kinks\",\"AllTrackID\":\"287\",\"iTunesTrackPreviewURL\":null,
        \"bonus\":1},{\"EventStart\":\"2019-02-25 14:44\",\"EventPlayedDate\":\"Today\",
        \"EventTime\":\"2.44pm\",\"Url\":\"/music/coldplay-743/paradise-16582/\",\"ArtistID\":\"743\",
        \"ArtistName\":\"Coldplay\",\"AllTrackTitle\":\"Paradise\",\"AllTrackID\":\"16582\",
        \"iTunesTrackPreviewURL\":null,\"bonus\":0}],\"template\":\"\"}",
      headers: [],
      status_code: 200
    }
  end

  defp empty_response(code) when code in [:ok, :created] do
    status_code = if code == :ok, do: 200, else: 201

    %HTTPoison.Response{
      body: "",
      headers: [],
      status_code: status_code
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
      body: "An response with some error",
      headers: [],
      status_code: 403
    }
  end
end
