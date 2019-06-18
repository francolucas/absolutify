defmodule Absolutify.Spotify.ApiRequestTest do
  use ExUnit.Case

  import Mock

  alias Absolutify.Mocks.Data
  alias Absolutify.Spotify.ApiRequest

  describe "ApiRequest.get/2" do
    test "pass the correct parameters to the function" do
      with_mock HTTPoison,
        get: fn url, headers -> %{url: url, headers: headers} end do
        credentials = Data.credentials()

        expected = %{
          url: "https://api.spotify.com/v1/get-url",
          headers: [
            "Content-Type": "application/json",
            Authorization: "Bearer #{credentials.access_token}"
          ]
        }

        assert ^expected = ApiRequest.get("/get-url", credentials)
      end
    end
  end

  describe "ApiRequest.post/2" do
    test "pass the correct parameters to the function" do
      with_mock HTTPoison,
        post: fn url, body, headers -> %{url: url, body: body, headers: headers} end do
        credentials = Data.credentials()

        expected = %{
          url: "https://api.spotify.com/v1/post-url",
          body: "",
          headers: [
            "Content-Type": "application/json",
            Authorization: "Bearer #{credentials.access_token}"
          ]
        }

        assert ^expected = ApiRequest.post("/post-url", credentials)
      end
    end
  end
end
