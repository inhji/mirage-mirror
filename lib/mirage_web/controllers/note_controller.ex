defmodule MirageWeb.NoteController do
  use MirageWeb, :controller

  def index_bookmark(conn, _params) do
    user = Mirage.Accounts.get_user()

    bookmarks =
      Mirage.Notes.list_notes(published: true, list: user.bookmark_list_id)
      |> Enum.group_by(fn note ->
        date = note.published_at || note.inserted_at

        date
        |> Timex.set(day: 1, hour: 0, minute: 0, second: 0)
        |> Timex.format!("{Mshort} {YYYY}")
      end)

    render(conn, "lists/bookmarks.html",
      notes: bookmarks,
      page_title: "Bookmarks",
      preview: true
    )
  end

  def show(conn, %{"id" => id}) do
    note = Mirage.Notes.get_note!(id)

    render(conn, "show.html",
      note: note,
      page_title: note.title,
      preview: false
    )
  end
end
