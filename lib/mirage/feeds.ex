defmodule Mirage.Feeds do
  alias Atomex.{Feed, Entry}
  alias MirageWeb.Router.Helpers, as: Routes

  @doc """
  Builds an rss/atom feed from the supplied entries
  """
  def render_feed(id, user) do
    id
    |> get_feed(user)
    |> build_feed(user)
  end

  defp get_feed("notes", user) do
    %{
      title: "Inhji.de Notes",
      entries:
        Mirage.Notes.list_notes(
          published: true,
          list: user.microblog_list_id,
          preload: true
        ),
      content_url: Routes.page_url(MirageWeb.Endpoint, :index),
      feed_url: Routes.page_url(MirageWeb.Endpoint, :index)
    }
  end

  defp get_feed("bookmarks", user) do
    %{
      title: "Inhji.de Notes",
      entries:
        Mirage.Notes.list_notes(
          published: true,
          list: user.bookmark_list_id,
          preload: true
        ),
      content_url: Routes.page_url(MirageWeb.Endpoint, :index),
      feed_url: Routes.page_url(MirageWeb.Endpoint, :index)
    }
  end

  defp get_feed("home", user) do
    get_feed("notes", user)
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
    |> Feed.author(user.name, email: user.email, uri: content_url)
    |> Feed.link(feed_url)
    |> Feed.entries(Enum.map(entries, fn entry -> get_entry(entry) end))
    |> Feed.build()
    |> Atomex.generate_document()
  end

  defp get_entry(%Mirage.Notes.Note{} = entry) do
    updated_at = DateTime.from_naive!(entry.updated_at, "Etc/UTC")
    published_at = DateTime.from_naive!(entry.published_at, "Etc/UTC")
    entry_url = Routes.note_url(MirageWeb.Endpoint, :show, entry)

    Entry.new(entry_url, updated_at, entry.title)
    |> Entry.published(published_at)
    |> Entry.content(entry.content, type: "text")
    |> Entry.content(entry.content_html, type: "html")
    |> Entry.link(entry_url)
    |> Entry.build()
  end
end
