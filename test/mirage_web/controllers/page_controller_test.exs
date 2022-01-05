defmodule MirageWeb.PageControllerTest do
  use MirageWeb.ConnCase

  setup :register_and_log_in_user

  test "GET /", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :index))
    assert html_response(conn, 200)
  end

  test "GET /about", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :about))
  end
end
