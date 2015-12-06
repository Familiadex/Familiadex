# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :familiada, Familiada.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "TjQWmBec5weDw1b8Pa0oO6g3lYKgLLVUgOIvU23yzoTMNuyGg3sksDI6eOT/3vsc",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Familiada.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

  config :ueberauth, Ueberauth,
    providers: [
      facebook: { Ueberauth.Strategy.Facebook, [] },
    ]

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: "1648610882054753",
  client_secret: System.get_env("FACEBOOK_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

defmodule RedisConf do
  def parse_db(nil), do: 0
  def parse_db("/"), do: 0
  def parse_db(path) do
    path |> String.split("/") |> Enum.at(1) |> String.to_integer
  end

  def parse_password(nil), do: ""
  def parse_password(auth) do
    auth |> String.split(":") |> Enum.at(1)
  end
end

if System.get_env("REDISTOGO_URL") do
  redis_info = URI.parse(System.get_env("REDISTOGO_URL"))
  # Configure redis
  config :exredis,
    host: redis_info.host,
    port: redis_info.port,
    password: redis_info.userinfo |> RedisConf.parse_password,
    db: redis_info.path |> RedisConf.parse_db,
    reconnect: :no_reconnect,
    max_queue: :infinity
end
