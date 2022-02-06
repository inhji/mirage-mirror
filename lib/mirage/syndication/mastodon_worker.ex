defmodule Mirage.Syndication.MastodonWorker do
  use Oban.Worker, queue: :syndication, max_attempts: 1
  require Logger
  alias MirageWeb.Router.Helpers, as: Routes

  def run(id, type) do
    %{id: id, type: type}
    |> __MODULE__.new()
    |> Oban.insert()
  end

  def perform(%Oban.Job{args: %{"id" => id, "type" => "note"} = _args}) do
    note = Mirage.Notes.get_note_by_id!(id)
    status_text = get_text(note)

    case Mirage.Mastodon.post_status(get_token(), status_text) do
      {:ok, url} ->
        syndication =
          note.syndications
          |> Enum.filter(fn syn -> syn.type == :mastodon end)
          |> List.first()

        Mirage.NoteSyndications.update_syndication(syndication, %{url: url})

      {:error, _} ->
        Logger.warn("Not updating syndication because of previous error")
    end
  end

  defp get_token() do
    user = Mirage.Accounts.get_user()
    %{token: token} = Mirage.Accounts.get_mastodon_user_token(user)

    token
  end

  defp get_text(note) do
    url = Routes.note_url(MirageWeb.Endpoint, :show, note)

    external_url =
      if not is_nil(note.url) do
        "#{note.url}\n"
      else
        ""
      end

    "#{external_url}#{note.content_sanitized}\n(Originally posted at #{url})"
  end
end
