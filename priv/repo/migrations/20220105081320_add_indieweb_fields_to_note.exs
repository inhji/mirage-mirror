defmodule Mirage.Repo.Migrations.AddIndiewebFieldsToNote do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      add :in_reply_to, :string
    end
  end
end
