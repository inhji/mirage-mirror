defmodule Mirage.Notes.NoteImage do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  schema "notes_images" do
    field :title, :string
    field :slug, Mirage.Notes.NoteSlug.Type

    field :content, :string
    field :content_html, :string

    field :filename, Mirage.Notes.NoteUploader.Type

    belongs_to :note, Mirage.Notes.Note

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:title, :content, :note_id])
    |> unique_constraint(:title)
    |> Mirage.Notes.NoteSlug.maybe_generate_slug()
    |> Mirage.Notes.NoteSlug.unique_constraint()
    |> Mirage.Markdown.maybe_render(:content, :content_html)
    |> validate_required([:title, :note_id])
  end

  def image_changeset(image, attrs) do
    image
    |> cast_attachments(attrs, [:filename], allow_paths: true)
  end
end
