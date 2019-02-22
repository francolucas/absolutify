defmodule Absolutify.Spotify.Responder do
  def handle_response(%HTTPoison.Response{body: response, status_code: code})
      when code in 200..201 do
    response
    |> Poison.decode()
  end

  def handle_response(%HTTPoison.Response{body: response, status_code: status_code})
      when status_code >= 400 do
    response
    |> Poison.decode()
    |> handle_error()
  end

  defp handle_error({:ok, %{"error_description" => error_description}}),
    do: {:error, error_description}

  defp handle_error(_error), do: {:error, "It was not possible to connect to Spotify"}
end
