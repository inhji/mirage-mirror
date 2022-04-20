defmodule Mirage.Repo.Migrations.AddCustomCss do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :custom_css, :text
    end
  end
end
