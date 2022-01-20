defmodule MirageWeb.Admin.NoteControllerTest do
  use MirageWeb.ConnCase

  import Mirage.NotesFixtures
  import Mirage.ListsFixtures

  @update_attrs %{
    content: "some updated content",
    title: "some updated title"
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
      conn = get(conn, Routes.admin_note_path(conn, :index))
      assert html_response(conn, 200) =~ "Notes"
    end
  end

  describe "new note" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_note_path(conn, :new))
      assert html_response(conn, 200) =~ "New Note"
    end
  end

  describe "create note" do
    setup [:create_list]

    test "redirects to show when data is valid", %{conn: conn, list: list, user: user} do
      create_attrs = %{
        content: "some content",
        title: "some title",
        tags_string: "some,tags",
        list_id: list.id,
        user_id: user.id
      }

      conn = post(conn, Routes.admin_note_path(conn, :create), note: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_note_path(conn, :show, id)

      conn = get(conn, Routes.admin_note_path(conn, :show, id))
      assert html_response(conn, 200) =~ create_attrs[:title]
      assert html_response(conn, 200) =~ "some"
      assert html_response(conn, 200) =~ "tags"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_note_path(conn, :create), note: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Note"
    end
  end

  describe "show note" do
    setup [:create_note]

    test "renders single note", %{conn: conn, note: note} do
      conn = get(conn, Routes.admin_note_path(conn, :show, note))
      assert html_response(conn, 200) =~ note.title
    end
  end

  describe "edit note" do
    setup [:create_note]

    test "renders form for editing chosen note", %{conn: conn, note: note} do
      conn = get(conn, Routes.admin_note_path(conn, :edit, note))
      assert html_response(conn, 200) =~ "Edit Note"
    end
  end

  describe "update note" do
    setup [:create_note]

    test "redirects when data is valid", %{conn: conn, note: note} do
      conn = put(conn, Routes.admin_note_path(conn, :update, note), note: @update_attrs)
      assert redirected_to(conn) == Routes.admin_note_path(conn, :show, note)

      conn = get(conn, Routes.admin_note_path(conn, :show, note))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, note: note} do
      conn = put(conn, Routes.admin_note_path(conn, :update, note), note: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Note"
    end
  end

  describe "publish note" do
    setup [:create_note]

    test "publishes a note", %{conn: conn, note: note} do
      conn = get(conn, Routes.admin_note_path(conn, :publish, note), id: note.id)
      assert redirected_to(conn) == Routes.admin_note_path(conn, :show, note)

      conn = get(conn, Routes.admin_note_path(conn, :show, note))
      assert html_response(conn, 200) =~ "Unpublish"
    end

    test "unpublishes a note", %{conn: conn, note: note} do
      conn = get(conn, Routes.admin_note_path(conn, :unpublish, note), id: note.id)
      assert redirected_to(conn) == Routes.admin_note_path(conn, :show, note)

      conn = get(conn, Routes.admin_note_path(conn, :show, note))
      assert html_response(conn, 200) =~ "Publish"
    end
  end

  describe "delete note" do
    setup [:create_note]

    test "deletes chosen note", %{conn: conn, note: note} do
      conn = delete(conn, Routes.admin_note_path(conn, :delete, note))
      assert redirected_to(conn) == Routes.admin_note_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_note_path(conn, :show, note))
      end
    end
  end
end
