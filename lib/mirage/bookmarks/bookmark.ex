defmodule Mirage.Bookmarks.Bookmark do
  @moduledoc """
  The Bookmark Schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @public_fields [
    :title,
    :slug,
    :url,
    :domain,
    :content,
    :content_html,
    :published_at,
    :views,
    :viewed_at
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder, only: @public_fields}
  @derive {Phoenix.Param, key: :slug}
  schema "bookmarks" do
    field :title, :string
    field :slug, Mirage.Bookmarks.BookmarkSlug.Type

    field :content, :string
    field :content_html, :string

    field :published_at, :naive_datetime

    field :url, :string
    field :domain, :string

    field :tags_string, :string,
      virtual: true,
      default: ""

    field :viewed_at, :naive_datetime
    field :views, :integer, default: 0

    field :bookmark_of, :string
    field :like_of, :string
    field :repost_of, :string

    belongs_to :list, Mirage.Lists.List
    belongs_to :user, Mirage.Accounts.User

    many_to_many :tags, Mirage.Tags.Tag, join_through: "bookmarks_tags"

    timestamps()
  end

  @doc false
  def changeset(bookmark, attrs) do
    bookmark
    |> cast(attrs, [
      :title,
      :slug,
      :content,
      :domain,
      :published_at,
      :like_of,
      :repost_of,
      :bookmark_of,
      :user_id,
      :list_id,
      :tags_string
    ])
    |> validate_required([
      :title,
      :content,
      :user_id,
      :list_id
    ])
    |> copy_url()
    |> Mirage.Bookmarks.BookmarkSlug.maybe_generate_slug()
    |> Mirage.Bookmarks.BookmarkSlug.unique_constraint()
    |> Mirage.Markdown.maybe_render(:content, :content_html)
  end

  def copy_url(changeset) do
    Enum.reduce_while([:like_of, :bookmark_of, :repost_of], changeset, fn field, changeset ->
      case get_change(changeset, field, nil) do
        nil ->
          {:cont, changeset}

        change ->
          changeset = put_change(changeset, :url, change)
          {:halt, changeset}
      end
    end)
  end
end
