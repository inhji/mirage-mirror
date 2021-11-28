defmodule MirageWeb.API.V1.NoteController do
  use MirageWeb, :controller

  alias Mirage.Notes
  alias Mirage.Notes.Note

  def search(conn, %{"query" => query} = params) do
    notes = Mirage.Notes.search_notes(query)

    json(conn, %{
      ok: true,
      data: notes
    })
  end
end
