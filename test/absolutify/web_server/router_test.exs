defmodule Absolutify.WebServer.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  alias Absolutify.{AuthenticationMock, Dynamic, DynamicMock}
  alias Absolutify.Spotify.Authentication
  alias Absolutify.WebServer.Router

  @opts Router.init([])

  describe "Route /" do
    test "returns 200" do
      conn = conn(:get, "/")
      conn = Router.call(conn, @opts)

      assert :sent == conn.state
      assert 200 == conn.status
    end
  end

  describe "Route /connect" do
    test "redirects to the correct URL" do
      conn = conn(:get, "/connect")
      conn = Router.call(conn, @opts)

      assert :set == conn.state
      assert 302 == conn.status
      assert true == conn.resp_headers |> extract_location() |> assert_location()
    end
  end

  describe "Route /callback" do
    test "authenticates when has a valid code" do
      with_mocks([
        {Authentication, [],
         auth: fn _credentials -> AuthenticationMock.auth(:valid_credentials) end},
        {Dynamic, [],
         start_crawler: fn _credentials -> DynamicMock.start_crawler(:credentials) end}
      ]) do
        conn = conn(:get, "/callback?code=valid_code")
        conn = Router.call(conn, @opts)

        assert :sent == conn.state
        assert 200 == conn.status
      end
    end

    test "returns 400 when has no valid code" do
      with_mock Authentication,
        auth: fn _credentials -> AuthenticationMock.auth(:invalid_credentials) end do
        conn = conn(:get, "/callback?code=invalid_code")
        conn = Router.call(conn, @opts)

        assert :sent == conn.state
        assert 400 == conn.status
      end
    end

    test "returns 400 when has no code" do
      conn = conn(:get, "/callback")
      conn = Router.call(conn, @opts)

      assert :sent == conn.state
      assert 400 == conn.status
    end
  end

  describe "Route /nonexistent" do
    test "returns 404 when the URL is invalid" do
      conn = conn(:get, "/nonexistent")
      conn = Router.call(conn, @opts)

      assert :sent == conn.state
      assert 404 == conn.status
    end
  end

  defp extract_location(headers) do
    [filtered | _tail] = Enum.filter(headers, fn {key, _value} -> "location" == key end)
    {_key, location} = filtered
    location
  end

  defp assert_location(location) do
    regex =
      ("^https:\/\/accounts\\.spotify\\.com\/en\/authorize\\?response_type=code&client_id=.+&redirect_uri=.+" <>
         "%2Fcallback&scope=playlist-read-private playlist-modify-private playlist-modify-public$")
      |> Regex.compile!()

    String.match?(location, regex)
  end
end
