defmodule MirageWeb.Admin.DashboardControllerTest do
  use MirageWeb.ConnCase

  setup :register_and_log_in_user

  describe "index" do
    test "renders without errors", %{conn: conn} do
      conn = get(conn, Routes.admin_dashboard_path(conn, :index))
      assert html_response(conn, 200)
    end
  end
end
