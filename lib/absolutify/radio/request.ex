defmodule Absolutify.Radio.Request do
  @url "https://absoluteradio.co.uk/_ajax/recently-played.php"
  @headers ["Content-Type": "application/x-www-form-urlencoded"]

  def post() do
    HTTPoison.post(@url, body(), @headers)
  end

  defp body() do
    "lastTime=#{:os.system_time(:second)}&serviceID=1&mode=more&searchTerm="
  end
end
