# Absolutify

**TODO: Add description**

## Requirements

**TODO: Add description**

## Usage

**TODO: Add description**

In `/config`, create a `config/secret.exs` file:

```elixir
use Mix.Config

config :absolutify,
  client_id: "<YOUR CLIENT ID>",
  secret_key: "<YOUR SECRET KEY>",
  callback_url: "<YOUR CALLBACK URL>",
  playlist_id: "<YOUR PLAYLIST ID>",
  code: "<THE AUTHORIZATION CODE GENERATED BY SPOTIFY WHEN YOU ALLOW THE APP>"
```
