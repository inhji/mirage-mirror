import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host =
    System.get_env("PUBLIC_HOST") ||
      raise """
      environment variable PUBLIC_HOST is missing.
      It should look like: example.com
      """

  data_dir =
    System.get_env("DATA_DIR") ||
      raise """
      environment variable DATA_DIR is missing.
      It should look like: /opt/mirage_data
      """

  upload_dir =
    System.get_env("UPLOAD_DIR") ||
      raise """
      environment variable UPLOAD_DIR is missing.
      It should look like: /var/www/mirage/files
      """

  instance_host =
    System.get_env("MASTODON_HOST") ||
      raise """
      environment variable MASTODON_HOST is missing.
      It should look like: chaos.social
      """

  client_id =
    System.get_env("MASTODON_ID") ||
      raise """
      environment variable MASTODON_ID is missing.
      It should look like: 0000000000000000000000000000000000000000000
      """

  client_secret =
    System.get_env("MASTODON_SECRET") ||
      raise """
      environment variable MASTODON_SECRET is missing.
      It should look like: 0000000000000000000000000000000000000000000
      """

  config :mirage, MirageWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: secret_key_base,
    cache_static_manifest: "priv/static/cache_manifest.json",
    server: true

  config :mirage, Mirage.Repo,
    # ssl: true,
    # socket_options: [:inet6],
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  config :tzdata, :data_dir, Path.join([data_dir, "tzdata"])

  config :mirage, :mastodon,
    instance_host: instance_host,
    client_id: client_id,
    client_secret: client_secret

  config :waffle,
    storage_dir_prefix: upload_dir

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :mirage, MirageWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :mirage, Mirage.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
end
