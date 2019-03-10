defmodule Absolutify.Radio.AbsoluteRadioTest do
  use ExUnit.Case

  import Mock

  alias Absolutify.Radio.{AbsoluteRadio, Request}
  alias Absolutify.RequestMock
  alias Absolutify.Track

  describe "AbsoluteRadio.latest_tracks/0" do
    test "returns a valid list with the most recent tracks played on the radio" do
      with_mock Request,
        post: fn -> RequestMock.post(:latest_tracks_success) end do
        {:ok, latest_tracks} = AbsoluteRadio.latest_tracks()
        assert 12 == latest_tracks |> Enum.filter(&match?(%Track{}, &1)) |> Enum.count()
      end
    end

    test "returns an expected error when it can not connect to the radio server" do
      with_mock Request,
        post: fn -> RequestMock.post(:unexpected_error) end do
        assert {:error, "Could not connect to the radio server."} = AbsoluteRadio.latest_tracks()
      end
    end

    test "returns an expected error when the radio server response is invalid" do
      with_mock Request,
        post: fn -> RequestMock.post(:empty_response_success) end do
        assert {:error, "Not expected result format from the radio server."} =
                 AbsoluteRadio.latest_tracks()
      end
    end

    test "returns an expected error when there is no valid track in the list from the radio" do
      with_mock Request,
        post: fn -> RequestMock.post(:latest_tracks_invalid_list) end do
        assert {:error, "There is no valid track in this request to the radio server."} =
                 AbsoluteRadio.latest_tracks()
      end
    end
  end

  describe "AbsoluteRadio.last_track/0" do
    test "returns the most recent track played on the radio" do
      with_mock Request,
        post: fn -> RequestMock.post(:latest_tracks_success) end do
        expected_track = Track.new(1_551_038_001, "Catfish And The Bottlemen", "Kathleen")
        assert {:ok, ^expected_track} = AbsoluteRadio.last_track()
      end
    end

    test "returns an expected error when it can not connect to the radio server" do
      with_mock Request,
        post: fn -> RequestMock.post(:unexpected_error) end do
        assert {:error, "Could not connect to the radio server."} = AbsoluteRadio.last_track()
      end
    end
  end
end
