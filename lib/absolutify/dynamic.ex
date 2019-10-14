defmodule Absolutify.Dynamic do
  use DynamicSupervisor

  alias Absolutify.Spotify.Credentials

  def start_link(_init_arg) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_crawler(%Credentials{} = credentials) do
    spec = %{id: Absolutify, start: {Absolutify, :start_link, [credentials]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
