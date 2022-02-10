defmodule Mirage.Repo.Migrations.AddListSettingsToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :bookmark_list_id, references(:lists, on_delete: :nothing, type: :binary_id)
      add :like_list_id, references(:lists, on_delete: :nothing, type: :binary_id)
    end
  end
end
