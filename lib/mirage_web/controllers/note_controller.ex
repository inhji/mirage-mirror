defmodule MirageWeb.NoteController do
  use MirageWeb, :controller

  def show(conn, %{"id" => id}) do
    note = Mirage.Notes.get_note!(id)

    render(conn, "show.html",
      note: note,
      page_title: note.title,
      preview: false
    )
  end
end
