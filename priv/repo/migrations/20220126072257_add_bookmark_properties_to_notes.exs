defmodule Mirage.Repo.Migrations.AddBookmarkPropertiesToNotes do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      add :url, :string
      add :url_type, :string
      add :domain, :string

      add :bookmark_of, :string
      add :like_of, :string
      add :repost_of, :string
    end
  end
end
