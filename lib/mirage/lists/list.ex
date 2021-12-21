defmodule Mirage.Lists.List do
  @moduledoc """
  The List Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :slug}
  schema "lists" do
    field :title, :string
    field :slug, Mirage.Lists.ListSlug.Type

    field :content, :string
    field :content_html, :string

    field :published_at, :naive_datetime

    field :display_type, Ecto.Enum, values: [:list, :gallery], default: :list

    field :viewed_at, :naive_datetime
    field :views, :integer

    has_many :notes, Mirage.Notes.Note

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [
      :title,
      :content,
      :display_type,
      :published_at,
      :viewed_at,
      :views
    ])
    |> validate_required([:title, :content])
    |> unique_constraint(:title)
    |> Mirage.Lists.ListSlug.maybe_generate_slug()
    |> Mirage.Lists.ListSlug.unique_constraint()
    |> Mirage.Markdown.maybe_render(:content, :content_html)
  end
end
