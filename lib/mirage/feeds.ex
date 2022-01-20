defmodule Mirage.Feeds do
  alias Atomex.{Feed, Entry}
  alias MirageWeb.Router.Helpers, as: Routes

  @doc """
  Builds an rss/atom feed from the supplied entries

  ## Note

  This uses XmlBuilder directly instead of Atomex.generate_document because of 
  https://github.com/Betree/atomex/pull/54
  """
  def render_feed(id, user) do
    id
    |> get_feed()
    |> build_feed(user)
  end

  defp get_feed("home") do
    %{
      title: "Home Feed",
      entries: Mirage.Content.list_updates(),
      content_url: Routes.page_url(MirageWeb.Endpoint, :index),
      feed_url: Routes.feed_url(MirageWeb.Endpoint, :show, "home")
    }
  end

  defp get_feed("bookmarks") do
    %{
      title: "Bookmarks Feed",
      entries: Mirage.Bookmarks.list_published_bookmarks(),
      content_url: Routes.bookmark_url(MirageWeb.Endpoint, :index),
      feed_url: Routes.feed_url(MirageWeb.Endpoint, :show, "bookmarks")
    }
  end

  defp get_feed("notes") do
    %{
      title: "Notes Feed",
      entries: Mirage.Notes.list_published_notes(),
      content_url: Routes.note_url(MirageWeb.Endpoint, :index),
      feed_url: Routes.feed_url(MirageWeb.Endpoint, :show, "notes")
    }
  end

  defp build_feed(
         %{
           title: title,
           entries: entries,
           content_url: content_url,
           feed_url: feed_url
         },
         user
       ) do
    Feed.new(content_url, DateTime.utc_now(), title)
    |> Feed.author(user.name, email: user.email)
    |> Feed.link(feed_url, rel: "self")
    |> Feed.entries(Enum.map(entries, fn entry -> get_entry(entry) end))
    |> Feed.build()
    |> XmlBuilder.document()
    |> XmlBuilder.generate()
  end

  defp get_entry(%Mirage.Notes.Note{} = entry) do
    updated_at = DateTime.from_naive!(entry.updated_at, "Etc/UTC")
    published_at = DateTime.from_naive!(entry.published_at, "Etc/UTC")
    entry_url = Routes.note_url(MirageWeb.Endpoint, :show, entry)

    Entry.new(entry_url, updated_at, entry.title)
    |> Entry.published(published_at)
    |> Entry.content(entry.content, type: "text")
    |> Entry.content(entry.content_html, type: "html")
    |> Entry.build()
  end

  defp get_entry(%Mirage.Bookmarks.Bookmark{} = entry) do
    updated_at = DateTime.from_naive!(entry.updated_at, "Etc/UTC")
    published_at = DateTime.from_naive!(entry.published_at, "Etc/UTC")
    entry_url = Routes.bookmark_url(MirageWeb.Endpoint, :show, entry)

    Entry.new(entry_url, updated_at, entry.title)
    |> Entry.published(published_at)
    |> Entry.content(entry.content, type: "text")
    |> Entry.content(entry.content_html, type: "html")
    |> Entry.build()
  end
end
