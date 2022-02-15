defmodule Mirage.Repo.Migrations.AddContentSanitizedToNote do
  use Ecto.Migration

  def up do
    alter table(:notes) do
      add :content_sanitized, :text
    end

    # flush()
    # repo().all(Mirage.Notes.Note)
    # |> Enum.each(fn note -> 
    #   text = HtmlSanitizeEx.strip_tags(note.content_html) 
    #   changeset = Ecto.Changeset.cast(note, %{content_sanitized: text}, [:content_sanitized])
    #   repo().update(changeset)
    # end)
  end

  def down do
    alter table(:notes) do
      remove :content_sanitized
    end
  end
end
