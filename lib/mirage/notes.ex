defmodule Mirage.Notes do
  @moduledoc """
  The Notes context.
  """

  import Ecto.Query, warn: false
  import Mirage.Macros
  alias Mirage.Repo

  alias Mirage.Notes.Note

  @doc """
  Returns the list of notes.

  ## Examples

      iex> list_notes()
      [%Note{}, ...]

  """
  def list_notes do
    Repo.all(Note)
  end

  @doc """
  Returns list of notes containg the given query_string

  ## Examplex

      iex> search_notes("foo")
      [%Note{}, ...]

  """
  def search_notes(query_string) do
    q =
      from n in Note,
        where: contains(n.content, ^query_string),
        or_where: contains(n.title, ^query_string)

    Repo.all(q)
  end

  @doc """
  Gets a single note.

  Raises `Ecto.NoResultsError` if the Note does not exist.

  ## Examples

      iex> get_note!(123)
      %Note{}

      iex> get_note!(456)
      ** (Ecto.NoResultsError)

  """
  def get_note!(id), do: Repo.get!(Note, id)

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
  Publishes a not by setting published_at to utc_now

  ## Examples

      iex> publish_note(note)
      {:ok, %Note{}}
      
  """
  def publish_note(%Note{} = note) do
    update_note(note, %{published_at: DateTime.utc_now()})
  end

  @doc """
  Unpublishes a not by setting published_at to nil

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
