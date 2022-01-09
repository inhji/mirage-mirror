defmodule Mirage.Repo.Migrations.AddSettingsToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :microblog_list_id, references(:lists, on_delete: :nothing, type: :binary_id)
      add :journal_list_id, references(:lists, on_delete: :nothing, type: :binary_id)
      add :motd, :text
    end
  end
end
