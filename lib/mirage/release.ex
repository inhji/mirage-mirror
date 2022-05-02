defmodule Mirage.Release do
  @moduledoc """
  Exposes functions for running migrations in production.
  """

  @doc """
  Runs all pending migrations on all repos.
  """
  def migrate do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  @doc """
  Rolls back one step on all repos.
  """
  def rollback(repo) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, step: 1))
  end

  defp repos do
    Application.load(:mirage)
    Application.fetch_env!(:mirage, :ecto_repos)
  end
end
