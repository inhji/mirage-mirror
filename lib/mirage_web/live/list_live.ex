defmodule MirageWeb.Live.ListLive do
  @doc """
  Returns a list of possible item orders
  """
  def order_by() do
    [
      {"Default Order", "default"},
      {"Creation Date, Newest First", "inserted_at_desc"},
      {"Publish Date, Newest First", "published_at_desc"},
      {"Creation Date, Oldest First", "inserted_at_asc"},
      {"Publish Date, Oldest First", "published_at_asc"}
    ]
  end

  def lists() do
    lists =
      Mirage.Lists.list_lists()
      |> Enum.map(fn list -> {list.title, list.id} end)

    [{"All", "all"} | lists]
  end

  def note_changeset(attrs \\ %{}) do
    params = %MirageWeb.Live.NoteListParams{}

    types = %{
      show_published: :string,
      show_list: :string,
      search_query: :string
    }

    {params, types}
    |> Ecto.Changeset.cast(attrs, Map.keys(types))
  end
end
