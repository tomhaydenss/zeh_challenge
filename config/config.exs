# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :zeh_challenge,
  ecto_repos: [ZehChallenge.Repo]

config :zeh_challenge, ZehChallenge.Repo, types: ZehChallenge.PostgisTypes

# Configures the endpoint
config :zeh_challenge, ZehChallengeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pFe+Fm9eHygu7CfKQ/spd8d1Z5hTVEMqk+nVmikTWjAGsp2435yUN23xUU5sMlYh",
  render_errors: [view: ZehChallengeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ZehChallenge.PubSub,
  live_view: [signing_salt: "rByQ6v5u"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :geo_postgis, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
