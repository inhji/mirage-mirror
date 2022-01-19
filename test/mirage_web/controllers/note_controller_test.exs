defmodule MirageWeb.NoteControllerTest do
  use MirageWeb.ConnCase
  import Mirage.NotesFixtures

  describe "NoteController" do
    setup [:create_note]

    test "GET /notes", %{conn: conn} do
      conn = get(conn, Routes.note_path(conn, :index))
      assert html_response(conn, 200) =~ "Notes"
    end

    test "GET /notes/:id", %{conn: conn, note: note} do
      conn = get(conn, Routes.note_path(conn, :show, note.slug))
      assert html_response(conn, 200) =~ note.title
    end

    test "GET /notes/:id/microformats", %{conn: conn, note: note} do
      conn = get(conn, Routes.note_path(conn, :microformats, note.slug))
      assert html_response(conn, 200) =~ note.title
    end
  end
end
