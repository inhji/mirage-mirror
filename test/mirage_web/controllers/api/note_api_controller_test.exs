defmodule MirageWeb.NoteApiControllerTest do
  use MirageWeb.ConnCase

  import Mirage.NotesFixtures

  describe "search" do
    test "searches notes by query", %{conn: conn} do
      note = note_fixture()
      conn = get(conn, Routes.api_v1_note_path(conn, :search, %{query: note.title}))
      body = json_response(conn, 200)

      assert body["ok"] == true
      assert body["data"] == []
    end
  end
end
