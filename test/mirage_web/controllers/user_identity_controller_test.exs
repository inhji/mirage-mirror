defmodule MirageWeb.UserIdentityControllerTest do
  use MirageWeb.ConnCase

  import Mirage.IdentitiesFixtures

  @create_attrs %{active: true, name: "some name", public: true, rel: "some rel", value: "some value"}
  @update_attrs %{active: false, name: "some updated name", public: false, rel: "some updated rel", value: "some updated value"}
  @invalid_attrs %{active: nil, name: nil, public: nil, rel: nil, value: nil}

  describe "index" do
    test "lists all users_identities", %{conn: conn} do
      conn = get(conn, Routes.user_identity_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users identities"
    end
  end

  describe "new user_identity" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_identity_path(conn, :new))
      assert html_response(conn, 200) =~ "New User identity"
    end
  end

  describe "create user_identity" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_identity_path(conn, :create), user_identity: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_identity_path(conn, :show, id)

      conn = get(conn, Routes.user_identity_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User identity"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_identity_path(conn, :create), user_identity: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User identity"
    end
  end

  describe "edit user_identity" do
    setup [:create_user_identity]

    test "renders form for editing chosen user_identity", %{conn: conn, user_identity: user_identity} do
      conn = get(conn, Routes.user_identity_path(conn, :edit, user_identity))
      assert html_response(conn, 200) =~ "Edit User identity"
    end
  end

  describe "update user_identity" do
    setup [:create_user_identity]

    test "redirects when data is valid", %{conn: conn, user_identity: user_identity} do
      conn = put(conn, Routes.user_identity_path(conn, :update, user_identity), user_identity: @update_attrs)
      assert redirected_to(conn) == Routes.user_identity_path(conn, :show, user_identity)

      conn = get(conn, Routes.user_identity_path(conn, :show, user_identity))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, user_identity: user_identity} do
      conn = put(conn, Routes.user_identity_path(conn, :update, user_identity), user_identity: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User identity"
    end
  end

  describe "delete user_identity" do
    setup [:create_user_identity]

    test "deletes chosen user_identity", %{conn: conn, user_identity: user_identity} do
      conn = delete(conn, Routes.user_identity_path(conn, :delete, user_identity))
      assert redirected_to(conn) == Routes.user_identity_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_identity_path(conn, :show, user_identity))
      end
    end
  end

  defp create_user_identity(_) do
    user_identity = user_identity_fixture()
    %{user_identity: user_identity}
  end
end
