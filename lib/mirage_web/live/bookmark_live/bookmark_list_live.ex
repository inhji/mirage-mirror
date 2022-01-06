defmodule MirageWeb.BookmarkListLive do
  use MirageWeb, :live_view
  alias MirageWeb.Live.ListLive

  def mount(_params, _info, socket) do
    bookmarks = Mirage.Bookmarks.list_bookmarks()

    {:ok,
     socket
     |> assign(%{
       bookmarks: bookmarks,
       changeset: ListLive.bookmark_changeset(),
       lists: ListLive.lists(),
       order_by: ListLive.order_by()
     })}
  end

  def handle_event("handle_change", %{"bookmark_list_params" => params}, socket) do
    bookmarks = Mirage.Bookmarks.list_bookmarks(params)
    {:noreply, socket |> assign(bookmarks: bookmarks, changeset: ListLive.bookmark_changeset(params))}
  end

  def handle_event("handle_reset", _params, socket) do
    bookmarks = Mirage.Bookmarks.list_bookmarks()
    {:noreply, socket |> assign(bookmarks: bookmarks, changeset: ListLive.bookmark_changeset())}
  end
end
