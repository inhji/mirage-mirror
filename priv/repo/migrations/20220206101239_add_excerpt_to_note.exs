defmodule Mirage.Repo.Migrations.AddExcerptToNote do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      add :excerpt, :text
      add :excerpt_html, :text
      add :excerpt_sanitized, :text
    end
  end
end
