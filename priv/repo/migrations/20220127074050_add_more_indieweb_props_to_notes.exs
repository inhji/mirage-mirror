defmodule Mirage.Repo.Migrations.AddMoreIndiewebPropsToNotes do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      add :watch_of, :string
      add :read_of, :string
      add :listen_of, :string
    end
  end
end
