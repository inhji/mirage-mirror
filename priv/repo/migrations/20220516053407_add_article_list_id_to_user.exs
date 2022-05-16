defmodule Mirage.Repo.Migrations.AddArticleListIdToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :article_list_id, references(:lists, on_delete: :nothing, type: :binary_id)
    end
  end
end
