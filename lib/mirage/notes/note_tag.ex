defmodule Mirage.Notes.NoteTag do
  @moduledoc """
  The NoteTag module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notes_tags" do
    belongs_to :note, Mirage.Notes.Note
    belongs_to :tag, Mirage.Tags.Tag
  end

  @doc false
  def changeset(note_tag, attrs) do
    note_tag
    |> cast(attrs, [:note_id, :tag_id])
    |> validate_required([:note_id, :tag_id])
  end
end
