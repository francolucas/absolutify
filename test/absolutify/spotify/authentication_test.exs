defmodule Absolutify.Spotify.AuthenticationTest do
  use ExUnit.Case

  import Mock

  alias Absolutify.RequestMock

  alias Absolutify.Spotify.{
    Authentication,
    AuthenticationRequest,
    Credentials
  }

  setup do
    Application.put_env(:absolutify, :code, "dR7gOOlpu8kku7MLdbEoGoU9eoEhedgaIxuCe6WT")
    Application.put_env(:absolutify, :callback_url, "http://localhost")
    Application.put_env(:absolutify, :client_id, "ni9DdjJvLrBk79GtOTUD")
    Application.put_env(:absolutify, :secret_key, "ebBMOu14UwTpElLdxZ7f")
  end

  describe "authentication" do
    test "authenticate using code" do
      with_mock AuthenticationRequest,
        post: fn _params -> RequestMock.post(:auth_success) end do
        assert {:ok, %Credentials{}} = Authentication.auth()
      end
    end

    test "user already authenticated" do
      expires_at = (:os.system_time(:seconds) + 3600) |> DateTime.from_unix!(:second)

      credentials = %Credentials{
        access_token: "a_valid_access_token",
        refresh_token: "a_valid_refresh_token",
        valid_until: expires_at
      }

      assert {:ok, ^credentials} = Authentication.auth(credentials)
    end

    test "authenticate with invalid code" do
      with_mock AuthenticationRequest,
        post: fn _params -> RequestMock.post(:auth_invalid_code) end do
        assert {:error, "Invalid authorization code"} = Authentication.auth()
      end
    end

    test "unexpected error request" do
      with_mock AuthenticationRequest,
        post: fn _params -> RequestMock.post(:unexpected_error) end do
        assert {:error, "It was not possible to connect to Spotify"} = Authentication.auth()
      end
    end
  end
end
