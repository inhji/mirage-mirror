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
    status_text = get_text(note, "note")

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

  defp get_text(note, _type) do
    max_length = 300
    url = Routes.note_url(MirageWeb.Endpoint, :show, note)

    content =
      note
      |> get_content()
      |> ellipsize_content(max_length)

    title_with_url = get_title_with_url(note)

    tags =
      if Enum.empty?(note.tags),
        do: "",
        else: get_tags(note.tags)

    "#{title_with_url}#{content}#{tags}(#{url})"
  end

  defp get_title_with_url(note) do
    external_url =
      if is_nil(note.url),
        do: "",
        else: note.url

    title =
      if Mirage.Notes.Note.has_datetitle?(note),
        do: "",
        else: note.title

    if title !== "" and external_url !== "" do
      "#{title} #{external_url}"
    else
      title
    end
  end

  defp get_content(note) do
    cond do
      note.excerpt_sanitized == nil ->
        note.content_sanitized

      String.length(note.excerpt_sanitized) > 0 ->
        note.content_sanitized

      true ->
        note.excerpt_sanitized
    end
  end

  defp ellipsize_content(content, max_length) do
    if String.length(content) >= max_length do
      String.slice(content, 0..(max_length - 2)) <> ".."
    else
      content
    end
  end

  defp get_tags(tag_list) do
    Enum.map_join(tag_list, " ", fn tag -> "##{tag.title}" end)
  end
end
