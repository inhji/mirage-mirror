defmodule MirageWeb.NoteControllerTest do
  use MirageWeb.ConnCase

  import Mirage.NotesFixtures

  @create_attrs %{
    content: "some content",
    content_html: "some content_html",
    published_at: ~N[2021-11-27 14:08:00],
    slug: "some slug",
    title: "some title",
    viewed_at: ~N[2021-11-27 14:08:00],
    views: 42
  }
  @update_attrs %{
    content: "some updated content",
    content_html: "some updated content_html",
    published_at: ~N[2021-11-28 14:08:00],
    slug: "some updated slug",
    title: "some updated title",
    viewed_at: ~N[2021-11-28 14:08:00],
    views: 43
  }
  @invalid_attrs %{
    content: nil,
    content_html: nil,
    published_at: nil,
    slug: nil,
    title: nil,
    viewed_at: nil,
    views: nil
  }

  setup :register_and_log_in_user

  describe "index" do
    test "lists all notes", %{conn: conn} do
      conn = get(conn, Routes.note_path(conn, :index))
      assert html_response(conn, 200) =~ "Notes"
    end
  end

  describe "new note" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.note_path(conn, :new))
      assert html_response(conn, 200) =~ "New Note"
    end
  end

  describe "create note" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.note_path(conn, :create), note: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.note_path(conn, :show, id)

      conn = get(conn, Routes.note_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Note"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.note_path(conn, :create), note: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Note"
    end
  end

  describe "edit note" do
    setup [:create_note]

    test "renders form for editing chosen note", %{conn: conn, note: note} do
      conn = get(conn, Routes.note_path(conn, :edit, note))
      assert html_response(conn, 200) =~ "Edit Note"
    end
  end

  describe "update note" do
    setup [:create_note]

    test "redirects when data is valid", %{conn: conn, note: note} do
      conn = put(conn, Routes.note_path(conn, :update, note), note: @update_attrs)
      assert redirected_to(conn) == Routes.note_path(conn, :show, note)

      conn = get(conn, Routes.note_path(conn, :show, note))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, note: note} do
      conn = put(conn, Routes.note_path(conn, :update, note), note: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Note"
    end
  end

  describe "publish note" do
    setup [:create_note]

    test "publishes a note", %{conn: conn, note: note} do
      conn = get(conn, Routes.note_path(conn, :publish, note), id: note.id)
      assert redirected_to(conn) == Routes.note_path(conn, :show, note)

      conn = get(conn, Routes.note_path(conn, :show, note))
      assert html_response(conn, 200) =~ "Unpublish"
    end

    test "unpublishes a note", %{conn: conn, note: note} do
      conn = get(conn, Routes.note_path(conn, :unpublish, note), id: note.id)
      assert redirected_to(conn) == Routes.note_path(conn, :show, note)

      conn = get(conn, Routes.note_path(conn, :show, note))
      assert html_response(conn, 200) =~ "Publish"
    end
  end

  describe "delete note" do
    setup [:create_note]

    test "deletes chosen note", %{conn: conn, note: note} do
      conn = delete(conn, Routes.note_path(conn, :delete, note))
      assert redirected_to(conn) == Routes.note_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.note_path(conn, :show, note))
      end
    end
  end

  defp create_note(_) do
    note = note_fixture()
    %{note: note}
  end
end
