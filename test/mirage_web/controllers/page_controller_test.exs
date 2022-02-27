defmodule MirageWeb.PageControllerTest do
  use MirageWeb.ConnCase

  setup :register_and_log_in_user

  test "GET /", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :index))
    assert html_response(conn, 200)
  end
end
