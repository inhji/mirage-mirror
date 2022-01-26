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
    note = Mirage.Notes.get_note!(id)
    url = Routes.note_url(MirageWeb.Endpoint, :show, id)
    status_text = get_text(note.content_sanitized, url)

    Mirage.Mastodon.post_status(get_token(), status_text)
  end

  defp get_token() do
    user = Mirage.Accounts.get_user()
    %{token: token} = Mirage.Accounts.get_mastodon_user_token(user)

    token
  end

  defp get_text(content, url) do
    "#{content} \n\n(Originally posted at #{url})"
  end
end
