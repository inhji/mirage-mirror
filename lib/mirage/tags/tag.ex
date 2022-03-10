defmodule Mirage.Tags.Tag do
  @moduledoc """
  The Tag Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :slug}
  schema "tags" do
    field :title, :string
    field :slug, Mirage.Tags.TagSlug.Type

    field :content, :string
    field :content_html, :string

    field :icon, :string
    field :regex, :string

    many_to_many :notes, Mirage.Notes.Note, join_through: "notes_tags"
    many_to_many :notes_unpublished, Mirage.Notes.Note, join_through: "notes_tags"
    many_to_many :notes_published, Mirage.Notes.Note, join_through: "notes_tags"

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:title, :content, :content_html, :icon, :regex])
    |> validate_required([:title])
    |> unique_constraint(:title)
    |> Mirage.Notes.NoteSlug.maybe_generate_slug()
    |> Mirage.Notes.NoteSlug.unique_constraint()
    |> Mirage.Markdown.maybe_render(:content, :content_html)
  end
end
