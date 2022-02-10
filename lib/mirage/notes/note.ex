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

    field :excerpt, :string
    field :excerpt_html, :string
    field :excerpt_sanitized, :string

    field :published_at, :naive_datetime

    field :viewed_at, :naive_datetime
    field :views, :integer, default: 0

    field :url, :string
    field :url_type, :string
    field :domain, :string

    field :in_reply_to, :string
    field :bookmark_of, :string
    field :like_of, :string
    field :repost_of, :string
    field :read_of, :string
    field :watch_of, :string
    field :listen_of, :string

    belongs_to :list, Mirage.Lists.List
    belongs_to :user, Mirage.Accounts.User

    has_many :syndications, Mirage.Notes.NoteSyndication

    many_to_many :tags, Mirage.Tags.Tag, join_through: "notes_tags"

    # Trigger field for the `syndicate_to` hook.
    field :syndication_targets, {:array, :string},
      virtual: true,
      default: []

    # Trigger field for the `add_tags` hook.
    field :tags_string, :string,
      virtual: true,
      default: ""

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
      :bookmark_of,
      :like_of,
      :repost_of,
      :read_of,
      :listen_of,
      :watch_of,
      :syndication_targets
    ])
    |> validate_required([:title, :content, :list_id, :user_id])
    |> unique_constraint(:title)
    |> Mirage.Notes.NoteSlug.maybe_generate_slug()
    |> Mirage.Notes.NoteSlug.unique_constraint()
    |> Mirage.Markdown.maybe_render(:content, :content_html)
    |> Mirage.Markdown.maybe_sanitize(:content_html, :content_sanitized)
    |> Mirage.Markdown.maybe_render(:excerpt, :excerpt_html)
    |> Mirage.Markdown.maybe_sanitize(:excerpt_html, :excerpt_sanitized)
    |> copy_url()
  end

  def copy_url(changeset) do
    url_fields = [
      :like_of,
      :bookmark_of,
      :repost_of,
      :watch_of,
      :listen_of,
      :read_of
    ]

    Enum.reduce_while(url_fields, changeset, fn field, changeset ->
      case get_change(changeset, field, nil) do
        nil ->
          {:cont, changeset}

        change ->
          changeset =
            changeset
            |> put_change(:url, change)
            |> put_change(:url_type, to_string(field))

          {:halt, changeset}
      end
    end)
  end
end
