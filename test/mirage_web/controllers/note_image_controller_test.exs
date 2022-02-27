defmodule MirageWeb.NoteImageControllerTest do
  # use MirageWeb.ConnCase

  # import Mirage.NotesFixtures

  # @create_attrs %{name: "some name"}
  # @update_attrs %{name: "some updated name"}
  # @invalid_attrs %{name: nil}

  # describe "index" do
  #   test "lists all notes_images", %{conn: conn} do
  #     conn = get(conn, Routes.admin_note_image_path(conn, :index))
  #     assert html_response(conn, 200) =~ "Listing Notes images"
  #   end
  # end

  # describe "new note_image" do
  #   test "renders form", %{conn: conn} do
  #     conn = get(conn, Routes.admin_note_image_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New Note image"
  #   end
  # end

  # describe "create note_image" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.admin_note_image_path(conn, :create), note_image: @create_attrs)

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.admin_note_image_path(conn, :show, id)

  #     conn = get(conn, Routes.admin_note_image_path(conn, :show, id))
  #     assert html_response(conn, 200) =~ "Show Note image"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.admin_note_image_path(conn, :create), note_image: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "New Note image"
  #   end
  # end

  # describe "edit note_image" do
  #   setup [:create_note_image]

  #   test "renders form for editing chosen note_image", %{conn: conn, note_image: note_image} do
  #     conn = get(conn, Routes.admin_note_image_path(conn, :edit, note_image))
  #     assert html_response(conn, 200) =~ "Edit Note image"
  #   end
  # end

  # describe "update note_image" do
  #   setup [:create_note_image]

  #   test "redirects when data is valid", %{conn: conn, note_image: note_image} do
  #     conn =
  #       put(conn, Routes.admin_note_image_path(conn, :update, note_image),
  #         note_image: @update_attrs
  #       )

  #     assert redirected_to(conn) == Routes.admin_note_image_path(conn, :show, note_image)

  #     conn = get(conn, Routes.admin_note_image_path(conn, :show, note_image))
  #     assert html_response(conn, 200) =~ "some updated name"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, note_image: note_image} do
  #     conn =
  #       put(conn, Routes.admin_note_image_path(conn, :update, note_image),
  #         note_image: @invalid_attrs
  #       )

  #     assert html_response(conn, 200) =~ "Edit Note image"
  #   end
  # end

  # describe "delete note_image" do
  #   setup [:create_note_image]

  #   test "deletes chosen note_image", %{conn: conn, note_image: note_image} do
  #     conn = delete(conn, Routes.admin_note_image_path(conn, :delete, note_image))
  #     assert redirected_to(conn) == Routes.admin_note_image_path(conn, :index)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.admin_note_image_path(conn, :show, note_image))
  #     end
  #   end
  # end

  # defp create_note_image(_) do
  #   note_image = note_image_fixture()
  #   %{note_image: note_image}
  # end
end
