# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :demo,
  ecto_repos: [Demo.Repo]

# Configures the endpoint
config :demo, DemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "k5qbv+0xG2pNYoB1K38IfBfsIJsiXW6kG4HRhjfNtfhe94+NPV4z52jX0sapPFC5",
  render_errors: [view: DemoWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Demo.PubSub, adapter: Phoenix.PubSub.PG2]

config :postgrex, :json_library, Jason

# Phauxth authentication configuration
config :phauxth,
  user_context: Demo.Accounts,
  crypto_module: Comeonin.Argon2,
  token_module: DemoWeb.Auth.Token

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phauxth,
  token_salt: "eetmUiKo",
  endpoint: DemoWeb.Endpoint

config :arc,
  storage: Arc.Storage.Local

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
