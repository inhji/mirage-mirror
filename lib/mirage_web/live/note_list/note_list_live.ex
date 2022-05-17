defmodule MirageWeb.NoteListLive do
  use MirageWeb, :live_view
  alias MirageWeb.Live.ListLive

  def mount(_params, _info, socket) do
    notes =
      [preload: true, limit: 10]
      |> parse_params()
      |> Mirage.Notes.list_notes()

    {:ok,
     socket
     |> assign(%{
       notes: notes,
       changeset: ListLive.note_changeset(),
       lists: ListLive.lists(),
       limit: ListLive.limit()
     })}
  end

  def handle_event("handle_change", %{"note_list_params" => params}, socket) do
    notes =
      params
      |> parse_params
      |> Mirage.Notes.list_notes()

    {:noreply, socket |> assign(notes: notes, changeset: ListLive.note_changeset(params))}
  end

  def handle_event("handle_reset", _params, socket) do
    notes =
      []
      |> parse_params
      |> Mirage.Notes.list_notes()

    {:noreply, socket |> assign(notes: notes, changeset: ListLive.note_changeset())}
  end

  def parse_params(params) do
    params
    |> Enum.into([])
    |> Enum.map(fn {k, v} ->
      if is_binary(k) do
        {String.to_atom(k), v}
      else
        {k, v}
      end
    end)
    |> Keyword.put_new(:preload, true)
  end
end
