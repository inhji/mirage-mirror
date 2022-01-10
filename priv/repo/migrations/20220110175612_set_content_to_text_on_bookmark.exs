defmodule Mirage.Repo.Migrations.SetContentToTextOnBookmark do
  use Ecto.Migration

  def change do
    alter table(:bookmarks) do
      modify :content, :text
      modify :content_html, :text
    end
  end
end
