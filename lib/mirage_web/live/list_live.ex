defmodule MirageWeb.Live.ListLive do
  def limit() do
    [
      {"10", "10"},
      {"25", "25"},
      {"50", "50"}
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
