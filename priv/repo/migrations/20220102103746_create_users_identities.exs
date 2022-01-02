defmodule Mirage.Repo.Migrations.CreateUsersIdentities do
  use Ecto.Migration

  def change do
    create table(:users_identities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :value, :string
      add :rel, :string
      add :active, :boolean, default: false, null: false
      add :public, :boolean, default: false, null: false
      add :user_id, references(:users)

      timestamps()
    end

    create index(:users_identities, [:user_id])
  end
end
