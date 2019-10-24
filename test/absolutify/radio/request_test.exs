defmodule Absolutify.Radio.RequestTest do
  use ExUnit.Case

  import Mock

  alias Absolutify.Radio.Request

  describe "Request.post/0" do
    test "pass the correct parameters to the function" do
      with_mock HTTPoison,
        get: fn url -> %{url: url} end do
        expected = %{
          url: "https://listenapi.planetradio.co.uk/api9/events/abr/now/48"
        }

        assert ^expected = Request.get()
      end
    end
  end
end
