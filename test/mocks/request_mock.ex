defmodule HTTPoison.Response do
  defstruct body: nil, headers: nil, status_code: nil
end

defmodule Absolutify.RequestMock do
  def post(:auth_success) do
    {:ok, auth_success_response()}
  end

  def post(:auth_invalid_code) do
    {:ok, auth_invalid_code_response()}
  end

  def post(:unexpected_error) do
    {:ok, failed_response_without_description()}
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
