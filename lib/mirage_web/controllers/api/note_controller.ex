defmodule MirageWeb.API.V1.NoteController do
  use MirageWeb, :controller

  alias Mirage.Notes

  def search(conn, %{"query" => query} = _params) do
    notes = Notes.search_notes(query)

    json(conn, %{
      ok: true,
      data: notes
    })
  end
end
