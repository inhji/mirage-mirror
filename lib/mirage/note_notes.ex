defmodule Mirage.NoteNotes do
  @moduledoc """
  The NoteNote context
  """

  import Ecto.Query, warn: false
  alias Mirage.Repo
  alias Mirage.Notes.NoteNote

  def get_note_note!(attrs \\ %{}) do
    Repo.get_by!(NoteNote, attrs)
  end

  def get_note_note(attrs \\ %{}) do
    Repo.get_by(NoteNote, attrs)
  end

  def create_note_note(attrs \\ %{}) do
    %NoteNote{}
    |> NoteNote.changeset(attrs)
    |> Repo.insert()
  end

  def delete_note_note(%NoteNote{} = note_note) do
    Repo.delete(note_note)
  end
end
