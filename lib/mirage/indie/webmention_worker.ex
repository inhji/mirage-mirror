defmodule Mirage.Indie.WebmentionWorker do
  use Oban.Worker, queue: :webmention

  def run(url) do
    %{url: url}
    |> __MODULE__.new()
    |> Oban.insert()
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"url" => url} = _args}) do
    try do
      case Webmentions.send_webmentions(url) do
        {:ok, responses} ->
          Enum.each(responses, fn response ->
            meta = Map.from_struct(response)
            Mirage.Logger.info("Webmention for url [#{url}] sent successfully!", meta)
          end)

        {:error, reason} ->
          Mirage.Logger.error("Sending webmention for url [#{url}] failed!", %{reason: reason})
      end
    rescue
      error ->
        Logger.warn("Error when sending webmentions!")
        Logger.error(inspect(__STACKTRACE__))
        Logger.error(inspect(error))

        Mirage.Logger.error("Sending webmention for url [#{url}] failed!", %{
          error: error,
          stacktrace: __STACKTRACE__
        })
    end

    :ok
  end
end
