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


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

redis_info = URI.parse(System.get_env("REDISTOGO_URL"))
# Configure redis
config :exredis,
  host: redis_info.host,
  port: redis_info.port,
  password: "",
  db: 0,
  reconnect: :no_reconnect,
  max_queue: :infinity
