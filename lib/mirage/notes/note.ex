defmodule Mirage.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notes" do
    field :content, :string
    field :content_html, :string
    field :published_at, :naive_datetime
    field :slug, :string
    field :title, :string
    field :viewed_at, :naive_datetime
    field :views, :integer

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :slug, :content, :content_html, :views, :viewed_at, :published_at])
    |> validate_required([:title, :slug, :content, :content_html, :views, :viewed_at, :published_at])
  end
end
