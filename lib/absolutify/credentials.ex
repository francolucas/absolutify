defmodule Absolutify.Credentials do
  alias Absolutify.Credentials

  defstruct [:access_token, :refresh_token]

  def new(%{"access_token" => access_token, "refresh_token" => refresh_token}, _credentials) do
    %Credentials{access_token: access_token, refresh_token: refresh_token}
  end

  def new(%{"access_token" => access_token}, %Credentials{} = credentials) do
    Map.put(credentials, :access_token, access_token)
  end
end
