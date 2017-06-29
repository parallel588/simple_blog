# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :simple_blog,
  ecto_repos: [SimpleBlog.Repo]

# Configures the endpoint
config :simple_blog, SimpleBlog.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5d4GytXMbAW8FvITLm1JnTmR+7RW8Ohknb8kjtYxKdhKPA9H9qNWYSgp78uqkQqw",
  render_errors: [view: SimpleBlog.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SimpleBlog.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "SimpleBlog",
  ttl: { 3, :days },
  verify_issuer: true,
  serializer: SimpleBlog.GuardianSerializer

config :simple_blog, SimpleBlog.Mailer,
  adapter: Swoosh.Adapters.Local

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
