defmodule MirageWeb.NoteController do
  use MirageWeb, :controller

  def index(conn, _params) do
    notes = Mirage.Notes.list_notes()
    render(conn, "index.html", notes: notes, page_title: "Notes")
  end

  def show(conn, %{"id" => id}) do
    note = Mirage.Notes.get_note!(id)
    render(conn, "show.html", note: note, page_title: note.title)
  end
end
