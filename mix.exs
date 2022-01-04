defmodule Mirage.MixProject do
  use Mix.Project

  @version "0.33.4"

  def project do
    [
      app: :mirage,
      version: @version,
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      docs: docs()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Mirage.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:atomex, "~> 0.4.1"},
      {:bcrypt_elixir, "~> 2.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:earmark, "~> 1.4"},
      {:ecto_autoslug_field, "~> 3.0"},
      {:ecto_sql, "~> 3.6"},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:floki, ">= 0.30.0"},
      {:gettext, "~> 0.18"},
      {:git_ops, "~> 2.4.5", only: :dev},
      {:jason, "~> 1.2"},
      {:hackney, "~> 1.18"},
      {:microformats2, "~> 0.7.4"},
      {:oban, "~> 2.10"},
      {:phoenix, "~> 1.6.2"},
      {:phoenix_active_link, "~> 0.3.1"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.0", override: true},
      {:phoenix_live_dashboard, "~> 0.5"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.16.0"},
      {:plug_cowboy, "~> 2.5"},
      {:postgrex, ">= 0.0.0"},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:tesla, "~> 1.4"},
      {:timex, "~> 3.7"},
      {:tzdata, "~> 1.1"},
      {:webmentions, "~> 2.0.0"}
    ]
  end

  defp docs do
    [
      # The main page in the docs
      main: "Mirage",
      logo: "priv/static/images/mirage.png",
      extras: ["README.md", "CHANGELOG.md"],
      output: "priv/static/docs",
      groups_for_modules: [
        Accounts: [~r/Mirage\.Accounts/],
        Lists: [~r/Mirage\.Lists/],
        Notes: [~r/Mirage\.Notes/],
        Tags: [~r/Mirage\.Tags/],
        MirageWeb: [~r/MirageWeb/]
      ],
      nest_modules_by_prefix: [
        MirageWeb,
        Mirage.Lists,
        Mirage.Notes,
        Mirage.Tags
      ]
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd --cd assets npm install"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": [
        "cmd npm run deploy --prefix assets",
        "esbuild default --minify"
      ],
      rel: ["git_ops.release --yes", "docs"],
      push: ["cmd bash ./scripts/deploy.sh"],
      deploy: [
        "phx.digest",
        "rel",
        "push",
        "cmd git push --follow-tags"
      ]
    ]
  end
end
