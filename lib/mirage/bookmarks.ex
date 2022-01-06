defmodule Mirage.Bookmarks do
  @moduledoc """
  The Bookmarks context.
  """

  import Ecto.Query, warn: false
  import Mirage.Queries

  alias Mirage.Repo
  alias Mirage.Bookmarks.{Bookmark, BookmarkHooks}

  @preloads [:list, :user]
  defp with_preloads(query), do: preload(query, ^@preloads)

  @doc """
  Preloads a bookmark with all defined preloads.

  ## Examples

      iex> preload_bookmark(bookmark)
      %Note{}

  """
  def preload_bookmark(bookmark), do: Repo.preload(bookmark, @preloads)

  @doc """
  Returns the list of bookmarks.

  ## Examples

      iex> list_bookmarks()
      [%Bookmark{}, ...]

  """
  def list_bookmarks do
    Bookmark
    |> with_preloads()
    |> Repo.all()
  end

  @doc """
  Returns the list of notes sorted by `MirageWeb.Live.NoteListParams`

  *Internal use only*
  """
  def list_bookmarks(opts) do
    Bookmark
    |> with_preloads()
    |> published_query(opts)
    |> list_query(opts)
    |> search_query(opts)
    |> order_by_query(opts)
    |> Repo.all()
  end

  @doc """
  Gets a single bookmark.

  Raises `Ecto.NoResultsError` if the Bookmark does not exist.

  ## Examples

      iex> get_bookmark!(123)
      %Bookmark{}

      iex> get_bookmark!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bookmark!(id),
    do:
      Repo.get_by!(Bookmark, slug: id)
      |> preload_bookmark()

  @doc """
  Creates a bookmark.

  ## Examples

      iex> create_bookmark(%{field: value})
      {:ok, %Bookmark{}}

      iex> create_bookmark(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bookmark(attrs \\ %{}) do
    %Bookmark{}
    |> Bookmark.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a bookmark and run the bookmark hooks.

  ## Examples

      iex> create_bookmark_with_hooks(%{field: value})
      {:ok, %Bookmark{}}

      iex> create_bookmark_with_hooks(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bookmark_with_hooks(attrs \\ %{}) do
    create_bookmark(attrs)
    |> BookmarkHooks.run_hooks(attrs)
  end

  @doc """
  Updates a bookmark.

  ## Examples

      iex> update_bookmark(bookmark, %{field: new_value})
      {:ok, %Bookmark{}}

      iex> update_bookmark(bookmark, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bookmark(%Bookmark{} = bookmark, attrs) do
    bookmark
    |> Bookmark.changeset(attrs)
    |> Repo.update()
  end

    @doc """
  Updates a bookmark and run the bookmark hooks.

  ## Examples

      iex> update_bookmark_with_hooks(bookmark, %{field: new_value})
      {:ok, %Bookmark{}}

      iex> update_bookmark_with_hooks(bookmark, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bookmark_with_hooks(%Bookmark{} = bookmark, attrs) do
    update_bookmark(bookmark, attrs)
    |> BookmarkHooks.run_hooks(attrs)
  end

    @doc """
  Publishes a bookmark by setting published_at to utc_now

  ## Examples

      iex> publish_bookmark(bookmark)
      {:ok, %Bookmark{}}
      
  """
  def publish_bookmark(%Bookmark{} = bookmark) do
    update_bookmark_with_hooks(bookmark, %{published_at: DateTime.utc_now()})
  end

  @doc """
  Unpublishes a bookmark by setting published_at to nil

  ## Examples

      iex> publish_bookmark(bookmark)
      {:ok, %Bookmark{}}
      
  """
  def unpublish_bookmark(%Bookmark{} = bookmark) do
    update_bookmark(bookmark, %{published_at: nil})
  end

  @doc """
  Deletes a bookmark.

  ## Examples

      iex> delete_bookmark(bookmark)
      {:ok, %Bookmark{}}

      iex> delete_bookmark(bookmark)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bookmark(%Bookmark{} = bookmark) do
    Repo.delete(bookmark)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bookmark changes.

  ## Examples

      iex> change_bookmark(bookmark)
      %Ecto.Changeset{data: %Bookmark{}}

  """
  def change_bookmark(%Bookmark{} = bookmark, attrs \\ %{}) do
    Bookmark.changeset(bookmark, attrs)
  end
end
