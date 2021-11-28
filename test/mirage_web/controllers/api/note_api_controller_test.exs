defmodule MirageWeb.API.NoteControllerTest do
  use MirageWeb.ConnCase

  import Mirage.NotesFixtures

  describe "search" do
    test "searches notes by query", %{conn: conn} do
      note = note_fixture()
      conn = get(conn, Routes.api_v1_note_path(conn, :search, %{query: note.title}))
      body = json_response(conn, 200)
      data = body["data"]

      assert body["ok"] == true
      assert Enum.count(data) == 1
      assert List.first(data)["title"] == note.title
    end
  end
end
