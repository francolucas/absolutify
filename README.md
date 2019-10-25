# Absolutify

[![CircleCI](https://circleci.com/gh/francolucas/absolutify.svg?style=svg)](https://circleci.com/gh/francolucas/absolutify)
[![Coverage Status](https://coveralls.io/repos/github/francolucas/absolutify/badge.svg?branch=master)](https://coveralls.io/github/francolucas/absolutify?branch=master)

An Elixir app created for studies purpose that checks "real-time" the songs played in [Absolute Radio](https://absoluteradio.co.uk/absolute-radio/) and inserts into a specific Spotify playlist.

## Requirements

- [A registered Spotify App](https://developer.spotify.com/documentation/general/guides/app-settings/#register-your-app)
  - Set `http://localhost:4002/callback` as Redirect URI
- A playlist ID from Spotify where the songs will be inserted into

## Usage

In `/config`, create a `config/dev.exs` file:

```elixir
use Mix.Config

config :absolutify,
  client_id: "<YOUR CLIENT ID>",
  secret_key: "<YOUR SECRET KEY>",
  playlist_id: "<YOUR PLAYLIST ID>",
```

Now you can run Absolutify with the following command:

```bash
mix run --no-halt
```

Access http://localhost:4002 on your browser and follow the instructions.

Once you authorize the app to access your playlist, in each minute, Absolutify will do the following commands:
1. Checks the latest song played at Absolute Radio and if it is different from the last check...
2. Searchs for the song in the Spotify and if exists...
3. Adds the song into the user's playlist.

## Next steps

- Write more tests.
- Style on the pages "/" and "/callback".
- Possibility to switch between other Absolute Radios (Classic Rock, 60s, etc).
- Since Absolute Radio returns a list of the latest played songs, parse the songs and connect to the Radio less often.
- Separate the `GenServer` in two: one checking the played songs and another one to search and add the song in the Spotify playlist.
- Better error handling.
- Better logs.
- Deploy in a cloud server.
- Check if the song already exists in the playlist to avoid repeated songs.
