defmodule MirageWeb.NoteListLive do
  use MirageWeb, :live_view

  def mount(_params, _info, socket) do
    notes = Mirage.Notes.list_notes()

    lists =
      Mirage.Lists.list_lists()
      |> Enum.map(fn list -> {list.title, list.id} end)

    lists = [{"All", "all"} | lists]

    {:ok, socket |> assign(changeset: changeset, notes: notes, lists: lists)}
  end

  def handle_event("handle_change", %{"note_list_params" => params}, socket) do
    IO.inspect(params)
    notes = Mirage.Notes.list_notes(params)
    {:noreply, socket |> assign(notes: notes, changeset: changeset(params))}
  end

  defp changeset(attrs \\ %{}) do
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
