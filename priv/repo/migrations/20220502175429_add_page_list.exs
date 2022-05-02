defmodule Mirage.Repo.Migrations.AddPageList do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :page_list_id, references(:lists, on_delete: :nothing, type: :binary_id)
    end
  end
end
