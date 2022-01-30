defmodule Mirage.Notes.NoteSyndication do
  @moduledoc """
  The NoteSyndication module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notes_syndications" do
    field :url, :string
    field :type, Ecto.Enum, values: [:mastodon, :github]

    belongs_to :note, Mirage.Notes.Note
  end

  @doc false
  def changeset(syndication, attrs) do
    syndication
    |> cast(attrs, [:note_id, :type, :url])
    |> validate_required([:note_id, :type])
  end
end
