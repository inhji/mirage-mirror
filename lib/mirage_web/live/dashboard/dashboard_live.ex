defmodule MirageWeb.DashboardLive do
  use MirageWeb, :live_view

  def mount(_params, _info, socket) do
    {:ok,
     socket
     |> assign(
       logs: get_logs(),
       jobs: get_jobs()
     )}
  end

  defp get_logs(), do: Mirage.Logger.list_logs()
  defp get_jobs(), do: Mirage.Jobs.list_jobs()
end
