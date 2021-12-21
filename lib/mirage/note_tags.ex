defmodule Mirage.NoteTags do
  @moduledoc """
  The NoteTags context
  """

  import Ecto.Query, warn: false
  alias Mirage.Repo
  alias Mirage.Notes.NoteTag

  def get_note_tag!(attrs \\ %{}) do
    Repo.get_by!(NoteTag, attrs)
  end

  def create_note_tag(attrs \\ %{}) do
    %NoteTag{}
    |> NoteTag.changeset(attrs)
    |> Repo.insert()
  end

  def delete_note_tag(%NoteTag{} = note_tag) do
    Repo.delete(note_tag)
  end
end
