defmodule MirageWeb.API.V1.NoteController do
  use MirageWeb, :controller

  alias Mirage.Notes
  alias Mirage.Notes.Note

  def search(conn, params) do
    json(conn, %{
      ok: true,
      data: []
    })
  end
end
