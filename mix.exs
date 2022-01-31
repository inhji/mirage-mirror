defmodule Mirage.MixProject do
  use Mix.Project

  @version "0.80.0"

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
      extra_applications: [:logger, :runtime_tools, :public_key]
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
      {:bcrypt_elixir, "~> 3.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:earmark, "1.4.20"},
      {:ecto_autoslug_field, "~> 3.0"},
      {:ecto_sql, "~> 3.6"},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:ex_doc, "~> 0.26", only: :dev, runtime: false},
      {:ex_machina, "~> 2.7", only: :test},
      {:exvcr, "~> 0.11", only: :test},
      {:floki, ">= 0.30.0"},
      {:gettext, "~> 0.18"},
      {:git_ops, "~> 2.4.5", only: :dev},
      {:hackney, "~> 1.18"},
      {:html_sanitize_ex, "~> 1.4"},
      {:jason, "~> 1.2"},
      {:mentat, "~> 0.7"},
      {:microformats2, "~> 1.0.0"},
      {:oauth2, "~> 2.0"},
      {:oban, "~> 2.10"},
      {:phoenix, "~> 1.6"},
      {:phoenix_active_link, "~> 0.3.1"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.0"},
      {:plug_cowboy, "~> 2.5"},
      {:plug_micropub, "~> 0.1.0"},
      {:postgrex, ">= 0.0.0"},
      {:rsa_ex, "~> 0.4"},
      {:scrivener_ecto, "~> 2.7"},
      {:scrivener_html, git: "https://github.com/goravbhootra/scrivener_html.git"},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:telemetry, "~> 1.0", override: true},
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
        "esbuild default --minify",
        "phx.digest"
      ],
      rel: ["git_ops.release --yes"],
      push: ["cmd bash ./scripts/deploy.sh"],
      deploy: [
        "docs",
        "rel",
        "push",
        "cmd git push --follow-tags"
      ]
    ]
  end
end
