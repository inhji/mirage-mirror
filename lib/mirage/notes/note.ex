defmodule Mirage.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notes" do
    field :title, :string
    # field :slug, Mirage.Notes.NoteSlug.Type
    field :slug, :string

    field :content, :string
    field :content_html, :string

    field :published_at, :naive_datetime

    field :viewed_at, :naive_datetime
    field :views, :integer

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :slug, :content, :content_html, :views, :viewed_at, :published_at])
    |> validate_required([:title, :content])
    |> unique_constraint(:title)
    |> Mirage.Notes.NoteSlug.maybe_generate_slug()
    |> Mirage.Notes.NoteSlug.unique_constraint()
    |> Mirage.Markdown.maybe_render(:content, :content_html)
  end
end
