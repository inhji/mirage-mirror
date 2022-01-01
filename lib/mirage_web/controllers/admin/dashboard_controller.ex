defmodule MirageWeb.Admin.DashboardController do
  use MirageWeb, :controller

  def index(conn, _params) do
    logs = Mirage.Logger.list_logs()
    render(conn, "index.html", logs: logs)
  end
end
