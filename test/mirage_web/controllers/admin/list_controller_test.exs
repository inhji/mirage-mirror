defmodule MirageWeb.Admin.ListControllerTest do
  use MirageWeb.ConnCase

  import Mirage.ListsFixtures

  @create_attrs %{
    content: "some content",
    display_type: :list,
    title: "some title"
  }
  @update_attrs %{
    content: "some updated content",
    display_type: :gallery,
    title: "some updated title"
  }
  @invalid_attrs %{
    content: nil,
    display_type: nil,
    title: nil
  }

  setup :register_and_log_in_user

  describe "index" do
    test "lists all lists", %{conn: conn} do
      conn = get(conn, Routes.admin_list_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Lists"
    end
  end

  describe "new list" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_list_path(conn, :new))
      assert html_response(conn, 200) =~ "New List"
    end
  end

  describe "create list" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_list_path(conn, :create), list: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_list_path(conn, :show, id)

      conn = get(conn, Routes.admin_list_path(conn, :show, id))
      assert html_response(conn, 200) =~ @create_attrs[:title]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_list_path(conn, :create), list: @invalid_attrs)
      assert html_response(conn, 200) =~ "New List"
    end
  end

  describe "edit list" do
    setup [:create_list]

    test "renders form for editing chosen list", %{conn: conn, list: list} do
      conn = get(conn, Routes.admin_list_path(conn, :edit, list))
      assert html_response(conn, 200) =~ "Edit List"
    end
  end

  describe "update list" do
    setup [:create_list]

    test "redirects when data is valid", %{conn: conn, list: list} do
      conn = put(conn, Routes.admin_list_path(conn, :update, list), list: @update_attrs)
      assert redirected_to(conn) == Routes.admin_list_path(conn, :show, list)

      conn = get(conn, Routes.admin_list_path(conn, :show, list))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, list: list} do
      conn = put(conn, Routes.admin_list_path(conn, :update, list), list: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit List"
    end
  end

  describe "publish list" do
    setup [:create_list]

    test "publishes a list", %{conn: conn, list: list} do
      conn = get(conn, Routes.admin_list_path(conn, :publish, list), id: list.id)
      assert redirected_to(conn) == Routes.admin_list_path(conn, :show, list)

      conn = get(conn, Routes.admin_list_path(conn, :show, list))
      assert html_response(conn, 200) =~ "Unpublish"
    end

    test "unpublishes a list", %{conn: conn, list: list} do
      conn = get(conn, Routes.admin_list_path(conn, :unpublish, list), id: list.id)
      assert redirected_to(conn) == Routes.admin_list_path(conn, :show, list)

      conn = get(conn, Routes.admin_list_path(conn, :show, list))
      assert html_response(conn, 200) =~ "Publish"
    end
  end

  describe "delete list" do
    setup [:create_list]

    test "deletes chosen list", %{conn: conn, list: list} do
      conn = delete(conn, Routes.admin_list_path(conn, :delete, list))
      assert redirected_to(conn) == Routes.admin_list_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_list_path(conn, :show, list))
      end
    end
  end
end
