defmodule Mirage.Indie.WebmentionWorker do
  use Oban.Worker, queue: :webmention, max_attempts: 3
  alias MirageWeb.Router.Helpers, as: Routes
  require Logger

  def run(id) do
    %{id: id}
    |> __MODULE__.new()
    |> Oban.insert()
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id} = _args}) do
    note = Mirage.Notes.get_note_by_id!(id)
    url = Routes.note_url(MirageWeb.Endpoint, :show, note)

    try do
      Logger.info("Sending webmentions for url [#{url}]!")

      case Webmentions.send_webmentions(url, ".e-content") do
        {:ok, responses} ->
          Enum.each(responses, fn response ->
            meta = Map.from_struct(response)
            Mirage.Logger.info("Webmention for url [#{response.target}] sent successfully!", meta)
          end)

        {:error, reason} ->
          Mirage.Logger.error("Sending webmention for url [#{url}] failed!", %{reason: reason})
      end
    rescue
      error ->
        Logger.warn("Error when sending webmentions!")
        Logger.error(inspect(__STACKTRACE__))
        Logger.error(Exception.message(error))

        Mirage.Logger.error("Sending webmention for url [#{url}] failed!", %{
          error: Exception.message(error)
        })
    end

    :ok
  end
end
