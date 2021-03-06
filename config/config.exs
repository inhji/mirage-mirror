# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :mirage,
  ecto_repos: [Mirage.Repo],
  generators: [binary_id: true]

config :mirage, Mirage.Repo, migration_primary_key: [name: :uuid, type: :binary_id]

# Configures the endpoint
config :mirage, MirageWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: MirageWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Mirage.PubSub,
  live_view: [signing_salt: "bLOC2bih"],
  user_agent: "Mirage/0.x +https://inhji.de"

config :mirage, :indie,
  token_endpoint: "https://tokens.indieauth.com/token",
  auth_endpoint: "https://indieauth.com/auth",
  supported_targets: [
    "mastodon"
  ],
  supported_scopes: [
    # Micropub scopes
    "create",
    "update",
    "delete",
    "undelete",
    "media"
  ]

# config :mirage, :mastodon,
#   enabled: false,
#   instance_url: "https://chaos.social",
#   client_id: "0000000000000000000000000000000000000000000",
#   client_secret: "0000000000000000000000000000000000000000000"

config :mirage, :mastodon,
  enabled: true,
  instance_url: "https://chaos.social",
  client_id: "YDyVFjIsHsb94EqDnLqXCFmQb0ZzP2qaMr4zRhSUYhA",
  client_secret: "MJK8pZykKg_MkL6Pe4IOH1ufOgECiKVDLicEpzrFGtM"

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :mirage, Mirage.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --loader:.woff2=file --loader:.woff=file --external:/fonts/* --external:/images/* --external:/favicon.ico),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :mirage, Oban,
  repo: Mirage.Repo,
  plugins: [{Oban.Plugins.Pruner, max_age: 300}],
  queues: [webmention: 10, syndication: 5]

config :scrivener_html,
  routes_helper: Mirage.Router.Helpers

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Set hackney as adapter for Tesla
config :tesla, adapter: Tesla.Adapter.Hackney

# Set tzdata as Timezone database
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Enable OAuth logging
config :oauth2, debug: true

# Configure image uploads
config :waffle,
  storage: Waffle.Storage.Local,
  storage_dir_prefix: "priv/waffle/public"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
