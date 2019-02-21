defmodule Absolutify.Radio.Request do
  @url "https://absoluteradio.co.uk/_ajax/recently-played.php"
  @headers ["Content-Type": "application/x-www-form-urlencoded"]

  def post() do
    HTTPoison.post(@url, body(), @headers)
    |> handle_response()
  end

  defp body() do
    "lastTime=#{:os.system_time(:second)}&serviceID=1&mode=more&searchTerm="
  end

  defp handle_response({:ok, %HTTPoison.Response{body: response, status_code: 200}}) do
    response
    |> Poison.decode()
  end

  defp handle_response(_response), do: {:error, "Could not connect to the radio server."}
end
