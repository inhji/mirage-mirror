defmodule Mirage.Notes.NoteNote do
  @moduledoc """
  The NoteNote module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notes_notes" do
    belongs_to :source, Mirage.Notes.Note
    belongs_to :target, Mirage.Notes.Note
  end

  @doc false
  def changeset(note_note, attrs) do
    note_note
    |> cast(attrs, [:source, :target])
    |> validate_required([:source, :target])
  end
end
