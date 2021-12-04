defmodule Mirage.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "lists" do
    field :content, :string
    field :content_html, :string
    field :display_type, Ecto.Enum, values: [:list, :gallery]
    field :published_at, :naive_datetime
    field :slug, :string
    field :title, :string
    field :viewed_at, :naive_datetime
    field :views, :integer

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :slug, :content, :content_html, :display_type, :published_at, :viewed_at, :views])
    |> validate_required([:title, :slug, :content, :content_html, :display_type, :published_at, :viewed_at, :views])
  end
end
