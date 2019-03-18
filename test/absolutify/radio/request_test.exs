defmodule Absolutify.Radio.RequestTest do
  use ExUnit.Case

  import Mock

  alias Absolutify.Radio.Request

  describe "Request.post/0" do
    test "pass the correct parameters to the function" do
      with_mock HTTPoison,
        post: fn url, body, headers -> %{url: url, body: body, headers: headers} end do
        expected = %{
          url: "https://absoluteradio.co.uk/_ajax/recently-played.php",
          body: "lastTime=#{:os.system_time(:second)}&serviceID=1&mode=more&searchTerm=",
          headers: ["Content-Type": "application/x-www-form-urlencoded"]
        }

        assert expected = Request.post()
      end
    end
  end
end
