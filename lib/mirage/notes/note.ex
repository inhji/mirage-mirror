defmodule Mirage.Notes.Note do
  @moduledoc """
  The Note Schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @public_fields [:title, :slug, :content, :content_html, :published_at, :views, :viewed_at]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: @public_fields}
  @derive {Phoenix.Param, key: :slug}
  schema "notes" do
    field :title, :string
    field :slug, Mirage.Notes.NoteSlug.Type

    field :content, :string
    field :content_html, :string
    field :content_sanitized, :string

    field :published_at, :naive_datetime

    field :should_publish, :boolean,
      virtual: true,
      default: false

    field :syndication_targets, {:array, :string},
      virtual: true,
      default: []

    field :viewed_at, :naive_datetime
    field :views, :integer, default: 0

    field :tags_string, :string,
      virtual: true,
      default: ""

    field :in_reply_to, :string

    belongs_to :list, Mirage.Lists.List
    belongs_to :user, Mirage.Accounts.User

    many_to_many :tags, Mirage.Tags.Tag, join_through: "notes_tags"

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [
      :title,
      :slug,
      :content,
      :published_at,
      :list_id,
      :tags_string,
      :user_id,
      :in_reply_to,
      :should_publish,
      :syndication_targets
    ])
    |> validate_required([:title, :content, :list_id, :user_id])
    |> unique_constraint(:title)
    |> Mirage.Notes.NoteSlug.maybe_generate_slug()
    |> Mirage.Notes.NoteSlug.unique_constraint()
    |> Mirage.Markdown.maybe_render(:content, :content_html)
    |> Mirage.Markdown.maybe_sanitize(:content_html, :content_sanitized)
  end
end
