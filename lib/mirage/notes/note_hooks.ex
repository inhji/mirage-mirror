defmodule Mirage.Notes.NoteHooks do
  @moduledoc """
  Defines hooks to be run when a Note is created or updated.

  Right now the available hooks are:

  * `update_tags/2`
  * `create_syndications/2`
  * `send_webmentions/2`
  * `syndicate_to/2`

  This could be refactored in a more general purpose hooks module.
  """

  require Logger
  alias Mirage.{Notes, Hooks}

  @targets_key "syndication_targets"

  def run_update_hooks(note, attrs) do
    update_hooks = [
      &update_tags/2,
      &create_syndications/2
    ]

    Hooks.run(note, attrs, update_hooks, &fetch_note/1)
  end

  def run_publish_hooks(note, attrs) do
    publish_hooks = [
      &send_webmentions/2,
      &syndicate_to/2
    ]

    Hooks.run(note, attrs, publish_hooks, &fetch_note/1)
  end

  defp fetch_note(n), do: Notes.get_note!(n.slug)

  # Update Hooks

  def update_tags(note, attrs) do
    {:ok,
     note
     |> Notes.preload_note()
     |> Mirage.Tags.TagUpdater.update_tags(attrs)}
  end

  def create_syndications(note, attrs) do
    Logger.info("Existing syndication targets: '#{Enum.count(note.syndications)}'")

    if Map.has_key?(attrs, @targets_key) and
         not Enum.empty?(attrs[@targets_key]) do
      Logger.info("New syndication targets: '#{attrs[@targets_key]}'")

      Enum.map(attrs[@targets_key], fn target ->
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

      {:ok, note}
    end
  end

  # Publish Hooks

  def send_webmentions(note, _attrs) do
    # Only syndicate if note is already published
    if !!note.published_at do
      Mirage.Indie.WebmentionWorker.run(note.id)
    end
  end

  def syndicate_to(note, _attrs) do
    # Only send webmentions if note is already published
    if !!note.published_at do
      targets = note.syndications

      Logger.info("Active syndication targets: #{inspect(targets)}")

      target = Enum.find(targets, nil, fn t -> t.type == :mastodon end)

      # Only publish to mastodon if syndication target is present
      if not is_nil(target) do
        Logger.info("Starting mastodon worker..")
        Mirage.Syndication.MastodonWorker.run(note.id, :note)
      end
    end
  end
end
