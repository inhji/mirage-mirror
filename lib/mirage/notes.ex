defmodule Mirage.Notes do
  @moduledoc """
  The Notes context.

  The Note is the primary piece of content. 
  It always is part of a `Mirage.Lists.List` and has multiple `Mirage.Tags.Tag`s.
  """

  import Ecto.Query, warn: false
  import Mirage.Macros
  import Mirage.Queries

  alias Mirage.Repo
  alias Mirage.Notes.{Note, NoteHooks}

  @preloads [:list, :tags, :user, :syndications, :images]
  defp with_preloads(query), do: preload(query, ^@preloads)

  @doc """
  Preloads a note with all defined preloads.

  ## Examples

      iex> preload_note(note)
      %Note{}

  """
  def preload_note(note), do: Repo.preload(note, @preloads)

  @doc """
  Defines the query other entities should preload notes with
  """
  def preload_query() do
    from(n in Mirage.Notes.Note)
  end

  def preload_query(:published) do
    from(n in Mirage.Notes.Note, where: not is_nil(n.published_at))
  end

  def preload_query(:unpublished) do
    from(n in Mirage.Notes.Note, where: is_nil(n.published_at))
  end

  @doc """
  Returns the list of notes.

  ## Examples

      iex> list_notes()
      [%Note{}, ...]

  """
  def list_notes do
    Note
    |> with_preloads()
    |> Repo.all()
  end

  def list_pages() do
    Note
    |> with_preloads()
    |> where([n], not is_nil(n.published_at))
    |> where([n], like(n.title, "@%"))
    |> order_by(desc: :title)
    |> Repo.all()
  end

  @doc """
  Returns the list of notes sorted by `MirageWeb.Live.NoteListParams`

  *Internal use only*
  """
  def list_notes(opts) do
    Note
    |> with_preloads()
    |> published_query(opts)
    |> list_query(opts)
    |> search_query(opts)
    |> order_by_query(opts)
    |> limit_query(opts)
    |> Repo.all()
  end

  @doc """
  Returns the list of published notes.

  ## Examples

      iex> list_notes()
      [%Note{}, ...]

  """
  def list_published_notes(pagination_params \\ %{}) do
    Note
    |> where([n], not is_nil(n.published_at))
    |> where([n], not like(n.title, "@%"))
    |> order_by(desc: :published_at)
    |> with_preloads()
    |> Repo.paginate(pagination_params)
  end

  @doc """
  Returns list of notes containg the given query_string

  ## Examplex

      iex> search_notes("foo")
      [%Note{}, ...]

  """
  def search_notes(query_string) do
    q =
      from(n in Note,
        where: contains(n.content, ^query_string),
        or_where: contains(n.title, ^query_string),
        preload: ^@preloads
      )

    Repo.all(q)
  end

  @doc """
  Gets a single note by its slug.

  Raises `Ecto.NoResultsError` if the Note does not exist.

  ## Examples

      iex> get_note!("some-note")
      %Note{}

      iex> get_note!("does-not-exist")
      ** (Ecto.NoResultsError)

  """
  def get_note!(slug),
    do:
      Repo.get_by!(Note, slug: slug)
      |> preload_note()

  @doc """
  Gets a single note by its id.

  Raises `Ecto.NoResultsError` if the Note does not exist.

  ## Examples

      iex> get_note!(123)
      %Note{}

      iex> get_note!(456)
      ** (Ecto.NoResultsError)

  """
  def get_note_by_id!(id),
    do:
      Repo.get!(Note, id)
      |> preload_note()

  @doc """
  Creates a note.

  ## Examples

      iex> create_note(%{field: value})
      {:ok, %Note{}}

      iex> create_note(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_note(attrs \\ %{}) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a note and runs the note hooks
  """
  def create_note_with_hooks(attrs \\ %{}) do
    create_note(attrs)
    |> NoteHooks.run_update_hooks(attrs)
  end

  @doc """
  Updates a note.

  ## Examples

      iex> update_note(note, %{field: new_value})
      {:ok, %Note{}}

      iex> update_note(note, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_note(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a note and runs the note hooks.
  """
  def update_note_with_hooks(%Note{} = note, attrs) do
    note
    |> update_note(attrs)
    |> NoteHooks.run_update_hooks(attrs)
  end

  @doc """
  Publishes a note by setting published_at to utc_now

  ## Examples

      iex> publish_note(note)
      {:ok, %Note{}}
      
  """
  def publish_note(%Note{} = note) do
    note
    |> update_note(%{published_at: DateTime.utc_now()})
    |> NoteHooks.run_publish_hooks(%{})
  end

  @doc """
  Unpublishes a note by setting published_at to nil

  ## Examples

      iex> publish_note(note)
      {:ok, %Note{}}
      
  """
  def unpublish_note(%Note{} = note) do
    update_note(note, %{published_at: nil})
  end

  @doc """
  Deletes a note.

  ## Examples

      iex> delete_note(note)
      {:ok, %Note{}}

      iex> delete_note(note)
      {:error, %Ecto.Changeset{}}

  """
  def delete_note(%Note{} = note) do
    Repo.delete(note)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking note changes.

  ## Examples

      iex> change_note(note)
      %Ecto.Changeset{data: %Note{}}

  """
  def change_note(%Note{} = note, attrs \\ %{}) do
    Note.changeset(note, attrs)
  end
end
