defmodule MirageWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :mirage

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_mirage_key",
    signing_salt: "P6nyEjSV"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [
      connect_info: [session: @session_options]
    ]

  # Serve uploads at /uploads
  plug Plug.Static,
    at: "/uploads",
    from: Path.expand("./priv/waffle/public/uploads"),
    gzip: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :mirage,
    gzip: false,
    only: ~w(assets docs fonts images manifest.json favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :mirage
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug MirageWeb.Router
end
