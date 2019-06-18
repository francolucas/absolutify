defmodule Absolutify.Spotify.AuthenticationRequestTest do
  use ExUnit.Case

  import Mock

  alias Absolutify.Spotify.AuthenticationRequest

  setup_all do
    Application.put_env(:absolutify, :client_id, "ni9DdjJvLrBk79GtOTUD")
    Application.put_env(:absolutify, :secret_key, "ebBMOu14UwTpElLdxZ7f")
  end

  describe "AuthenticationRequest.post/1" do
    test "pass the correct parameters to the function" do
      with_mock HTTPoison,
        post: fn url, body, headers -> %{url: url, body: body, headers: headers} end do
        expected = %{
          url: "https://accounts.spotify.com/api/token",
          body: "body",
          headers: [
            "Content-Type": "application/x-www-form-urlencoded",
            Authorization: "Basic #{:base64.encode("ni9DdjJvLrBk79GtOTUD:ebBMOu14UwTpElLdxZ7f")}"
          ]
        }

        assert ^expected = AuthenticationRequest.post("body")
      end
    end
  end
end
