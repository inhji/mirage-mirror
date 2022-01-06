defmodule Mirage.Notes.NoteHooks do
  @moduledoc """
  Defines hooks to be run when a Note is created or updated.

  Right now the available hooks are:

  * `update_tags/2`
  * `send_webmentions/2`

  This could be refactored in a more general purpose hooks module.
  """

  require Logger
  alias MirageWeb.Router.Helpers, as: Routes

  def run_hooks(result, attrs) do
    Mirage.Hooks.run(result, attrs, [
      &update_tags/2,
      &send_webmentions/2
    ])
  end

  def update_tags(note, attrs) do
    {:ok,
     note
     |> Mirage.Notes.preload_note()
     |> Mirage.Tags.TagUpdater.update_tags(attrs)}
  end

  def send_webmentions(note, _attrs) do
    # Only send webmentions if note is already published
    if note.published_at do
      url = Routes.note_url(MirageWeb.Endpoint, :show, note)
      Mirage.Indie.WebmentionWorker.run(url)
    end
  end
end
