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
  alias Mirage.Notes.NoteLinkUpdater

  @targets_key "syndication_targets"

  def run_update_hooks(note, attrs) do
    update_hooks = [
      &update_references/2,
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

  def update_references(note, attrs) do
    new_reference_slugs = Mirage.References.get_reference_ids(attrs["content"])
    old_reference_slugs = Enum.map(note.links_from, fn n -> n.slug end)

    Logger.info("Existing links from: #{Enum.count(note.links_from)}")
    Logger.info("Existing links to: #{Enum.count(note.links_to)}")

    references_to_add = new_reference_slugs -- old_reference_slugs
    Logger.info("Adding #{Enum.count(references_to_add)} references:")
    Logger.info(inspect(references_to_add))
    NoteLinkUpdater.add_note_links(note, references_to_add)

    references_to_remove = old_reference_slugs -- new_reference_slugs
    Logger.info("Removing #{Enum.count(references_to_remove)} references")
    Logger.info(inspect(references_to_remove))
    NoteLinkUpdater.remove_note_links(note, references_to_remove)

    {:ok, note}
  end

  def create_syndications(note, attrs) do
    Logger.info("Existing syndication targets: '#{Enum.count(note.syndications)}'")

    has_key = Map.has_key?(attrs, @targets_key)
    entries = Map.get(attrs, @targets_key, [])
    has_entries = not Enum.empty?(entries)

    Logger.info("Has Syndication Key: #{has_key}")
    Logger.info("Has Syndication Entries: #{has_entries}")

    if has_key and has_entries do
      Logger.info("New syndication targets: '#{attrs[@targets_key]}'")

      Enum.each(attrs[@targets_key], fn target ->
        do_create_syndication(note, target)
      end)

      {:ok, note}
    end
  end

  def do_create_syndication(note, target) do
    case Mirage.NoteSyndications.get_syndication(note, target) do
      nil ->
        Logger.info("Creating new syndication for target '#{target}'")

        {:ok, _syndication} =
          Mirage.NoteSyndications.create_syndication(%{
            note_id: note.id,
            type: String.to_existing_atom(target)
          })

        Logger.info("Syndication for '#{target}' created!")

      _syndication ->
        Logger.info("Syndication for '#{target}' already exists.")
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
    # Only syndicate if note is already published
    if !!note.published_at do
      targets = note.syndications

      Logger.info("Active syndication targets: #{inspect(targets)}")

      # Find the note's target that is of type mastodon
      # and does not have a url yet. This makes sure syndications 
      # are not done more than once.
      target =
        Enum.find(targets, nil, fn t ->
          t.type == :mastodon and t.url == nil
        end)

      # Only publish to mastodon if syndication target is present
      if not is_nil(target) do
        Logger.info("Starting mastodon worker..")
        Mirage.Syndication.MastodonWorker.run(note.id, :note)
      end
    end
  end
end
