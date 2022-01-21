defmodule Mirage.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Mirage.Repo,
      # Start the Telemetry supervisor
      MirageWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Mirage.PubSub},
      # Start the Endpoint (http/https)
      MirageWeb.Endpoint,
      # Start oban
      {Oban, oban_config()},
      # Start a worker by calling: Mirage.Worker.start_link(arg)
      {Mentat, name: :mastodon_creds}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mirage.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Conditionally disable queues or plugins here.
  defp oban_config do
    Application.fetch_env!(:mirage, Oban)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MirageWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
