# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :policy_api, PolicyApiWeb.Auth.Guardian,
  issuer: "policy_api",
  secret_key: "tY+vtstPbJvUdaLujAUKLPZuU3GEaXT7zoW2UzCxY5jyHEZ3+3ByJ8RPgSNV1E+x"

config :hound,
  driver: "chrome_driver"
  #browser: "chrome_headless"


config :policy_api,
  ecto_repos: [PolicyApi.Repo]

# Configures the endpoint
config :policy_api, PolicyApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hxffTaL9wT5c/ssg3prdSO+cEoeVygD2Ua+RZxV0CbsLDqSPXxXBLkgrm/sb5AAQ",
  render_errors: [view: PolicyApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: PolicyApi.PubSub,
  live_view: [signing_salt: "6dR5d3vr"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
