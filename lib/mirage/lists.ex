defmodule Mirage.Lists do
  @moduledoc """
  The Lists context.
  """

  import Ecto.Query, warn: false
  alias Mirage.Repo

  alias Mirage.Lists.List

  @preloads [notes: Mirage.Notes.preload_query()]
  def preload_list(list), do: Repo.preload(list, @preloads)
  defp with_preloads(query), do: preload(query, ^@preloads)

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """
  def list_lists do
    List
    |> with_preloads()
    |> Repo.all()
  end

  @doc """
  Returns the list of published lists.

  ## Examples

      iex> list_published_lists()
      [%List{}, ...]

  """
  def list_published_lists do
    List
    |> where([l], is_nil(l.published_at) == false)
    |> with_preloads()
    |> Repo.all()
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(slug),
    do:
      Repo.get_by!(List, slug: slug)
      |> preload_list()

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(attrs \\ %{}) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(%List{} = list, attrs) do
    list
    |> List.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Publishes a note by setting published_at to utc_now

  ## Examples

      iex> publish_list(list)
      {:ok, %list{}}
      
  """
  def publish_list(%List{} = list) do
    update_list(list, %{published_at: DateTime.utc_now()})
  end

  @doc """
  Unpublishes a not by setting published_at to nil

  ## Examples

      iex> publish_list(list)
      {:ok, %list{}}
      
  """
  def unpublish_list(%List{} = list) do
    update_list(list, %{published_at: nil})
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    Repo.delete(list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %List{}}

  """
  def change_list(%List{} = list, attrs \\ %{}) do
    List.changeset(list, attrs)
  end

  @doc """
  Formats a list for use in a select html element
  """
  def for_select(%List{} = list) do
    [key: list.title, value: list.id]
  end
end
