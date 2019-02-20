defmodule HTTPoison.Response do
  defstruct body: nil, headers: nil, status_code: nil
end

defmodule Absolutify.Spotify.AuthenticationRequestMock do
  def post(:spotify_error_response) do
    {:ok, failed_response()}
  end

  def post(:unexpected_error) do
    {:ok, failed_response_without_description()}
  end

  def post(_params) do
    {:ok, successful_response()}
  end

  defp failed_response do
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

  defp successful_response do
    %HTTPoison.Response{
      body: "{\"access_token\":\"a_valid_access_token\",\"token_type\":\"Bearer\",
        \"expires_in\":3600,\"refresh_token\":\"a_valid_refresh_token\",
        \"scope\":\"playlist-read-private playlist-modify-private playlist-modify-public\"}",
      headers: [],
      status_code: 200
    }
  end
end
