defmodule MirageWeb.NoteListLive do
  use MirageWeb, :live_view
  alias MirageWeb.Live.ListLive

  def mount(_params, _info, socket) do
    notes = Mirage.Notes.list_notes()

    {:ok,
     socket
     |> assign(%{
       notes: notes,
       changeset: ListLive.note_changeset(),
       lists: ListLive.lists(),
       order_by: ListLive.order_by()
     })}
  end

  def handle_event("handle_change", %{"note_list_params" => params}, socket) do
    notes = Mirage.Notes.list_notes(params)
    {:noreply, socket |> assign(notes: notes, changeset: ListLive.note_changeset(params))}
  end

  def handle_event("handle_reset", _params, socket) do
    notes = Mirage.Notes.list_notes()
    {:noreply, socket |> assign(notes: notes, changeset: ListLive.note_changeset())}
  end
end
