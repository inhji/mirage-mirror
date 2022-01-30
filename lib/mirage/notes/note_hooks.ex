defmodule Mirage.Notes.NoteHooks do
  @moduledoc """
  Defines hooks to be run when a Note is created or updated.

  Right now the available hooks are:

  * `publish/2`
  * `update_tags/2`
  * `send_webmentions_if_published/2`
  * `syndicate_to_if_published/2`

  This could be refactored in a more general purpose hooks module.
  """

  require Logger
  alias MirageWeb.Router.Helpers, as: Routes

  def run_hooks(note, attrs) do
    Mirage.Hooks.run(
      note,
      attrs,
      [
        &publish/2,
        &update_tags/2,
        &create_syndications/2,
        &send_webmentions_if_published/2,
        &syndicate_to_if_published/2
      ],
      &Mirage.Notes.get_note!(&1.slug)
    )
  end

  def publish(note, attrs) do
    if Map.get(attrs, :should_publish, false) do
      {:ok,
       note
       |> Mirage.Notes.publish_note()}
    end
  end

  def update_tags(note, attrs) do
    {:ok,
     note
     |> Mirage.Notes.preload_note()
     |> Mirage.Tags.TagUpdater.update_tags(attrs)}
  end

  def send_webmentions_if_published(note, _attrs) do
    # Only syndicate if note is already published
    if !!note.published_at do
      url = Routes.note_url(MirageWeb.Endpoint, :show, note)
      Mirage.Indie.WebmentionWorker.run(url)
    end
  end

  def create_syndications(note, attrs) do
    Logger.info("Syndication targets: '#{Enum.count(note.syndications)}'")

    if Map.has_key?(attrs, "syndication_targets") and
         not Enum.empty?(attrs["syndication_targets"]) do
      Enum.map(attrs["syndication_targets"], fn target ->
        case Mirage.NoteSyndications.get_syndication(note, target) do
          nil ->
            Logger.info("Creating new syndication for target '#{target}'")

            {:ok, syndication} =
              Mirage.NoteSyndications.create_syndication(%{
                note_id: note.id,
                type: String.to_existing_atom(target)
              })

            syndication

          syndication ->
            Logger.info("Syndication for '#{target}' already exists.")

            syndication
        end
      end)
    end
  end

  def syndicate_to_if_published(note, attrs) do
    # Only send webmentions if note is already published
    if !!note.published_at and Map.has_key?(attrs, "syndication_targets") do
      targets = attrs["syndication_targets"]

      Logger.info("Active syndication targets: #{inspect(targets)}")

      # Only publish to mastodon if syndication target is present
      if Enum.member?(targets, "mastodon") do
        Logger.info("Starting mastodon worker..")
        Mirage.Syndication.MastodonWorker.run(note.id, :note)
      end
    end
  end
end
