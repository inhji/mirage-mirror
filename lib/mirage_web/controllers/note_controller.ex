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

  def microformats(conn, %{"id" => id}) do
    note = Mirage.Notes.get_note!(id)

    mf2 =
      conn
      |> Routes.note_url(:show, id)
      |> Microformats2.parse()

    render(conn, "microformats.html", note: note, microformats: inspect(mf2, pretty: true))
  end
end
