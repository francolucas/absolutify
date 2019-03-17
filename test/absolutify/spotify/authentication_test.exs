defmodule Absolutify.Spotify.AuthenticationTest do
  use ExUnit.Case

  import Mock

  alias Absolutify.RequestMock

  alias Absolutify.Spotify.{
    Authentication,
    AuthenticationRequest,
    Credentials
  }

  setup_all do
    Application.put_env(:absolutify, :code, "dR7gOOlpu8kku7MLdbEoGoU9eoEhedgaIxuCe6WT")
    Application.put_env(:absolutify, :callback_url, "http://localhost")
  end

  describe "Authentication.auth/0" do
    test "authenticates using a valid code" do
      with_mock AuthenticationRequest,
        post: fn _params -> RequestMock.post(:auth_success) end do
        {:ok, %Credentials{} = credentials} = Authentication.auth()

        assert !is_nil(credentials.access_token) and !is_nil(credentials.refresh_token) and
                 !is_nil(credentials.valid_until)
      end
    end

    test "returns an expected error when it tries to authenticate with an invalid code" do
      with_mock AuthenticationRequest,
        post: fn _params -> RequestMock.post(:auth_invalid_code) end do
        assert {:error, "Invalid authorization code"} = Authentication.auth()
      end
    end
  end

  describe "Authentication.auth/1" do
    test "does not change the current credentials if its a valid one" do
      expires_at =
        :seconds
        |> :os.system_time()
        |> Kernel.+(3600)
        |> DateTime.from_unix!(:second)

      credentials = %Credentials{
        access_token: "a_valid_access_token",
        refresh_token: "a_valid_refresh_token",
        valid_until: expires_at
      }

      assert {:ok, ^credentials} = Authentication.auth(credentials)
    end

    test "returns new credentials if the current one is expired" do
      expires_at = (:os.system_time(:seconds) - 10) |> DateTime.from_unix!(:second)

      expired_credentials = %Credentials{
        access_token: "a_valid_access_token",
        refresh_token: "a_valid_refresh_token",
        valid_until: expires_at
      }

      with_mock AuthenticationRequest,
        post: fn _params -> RequestMock.post(:refresh_token_success) end do
        {:ok, %Credentials{} = new_credentials} = Authentication.auth(expired_credentials)

        refute expired_credentials == new_credentials
        assert new_credentials.valid_until > expired_credentials.valid_until
      end
    end
  end
end
