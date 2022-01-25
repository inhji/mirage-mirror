defmodule Mirage.Bookmarks.BookmarkHooks do
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
      &publish/2,
      &update_tags/2,
      &send_webmentions/2,
      &syndicate_to/2
    ])
  end

  def publish(bookmark, attrs) do
    if Map.get(attrs, :should_publish, false) do
      {:ok,
       bookmark
       |> Mirage.Bookmarks.publish_bookmark()}
    end
  end

  def update_tags(bookmark, attrs) do
    {:ok,
     bookmark
     |> Mirage.Bookmarks.preload_bookmark()
     |> Mirage.Tags.TagUpdater.update_tags(attrs)}
  end

  def send_webmentions(bookmark, _attrs) do
    # Only send webmentions if bookmark is already published
    if bookmark.published_at do
      url = Routes.bookmark_url(MirageWeb.Endpoint, :show, bookmark)
      Mirage.Indie.WebmentionWorker.run(url)
    end
  end

  def syndicate_to(bookmark, attrs) do
    # Only send webmentions if bookmark is already published
    if !!bookmark.published_at and Enum.member?(attrs, "syndication_targets") do
      targets = attrs["syndication_targets"]

      # Only publish to mastodon if syndication target is present
      if Enum.member?(targets, "mastodon") do
        Mirage.Syndication.MastodonWorker.run(bookmark.id, :bookmark)
      end
    end
  end
end
