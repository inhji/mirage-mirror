defmodule Mirage.Identities do
  @moduledoc """
  The Identities context.
  """

  import Ecto.Query, warn: false
  alias Mirage.Repo

  alias Mirage.Identities.UserIdentity

  @doc """
  Returns the list of users_identities.

  ## Examples

      iex> list_users_identities()
      [%UserIdentity{}, ...]

  """
  def list_user_identities(%Mirage.Accounts.User{} = user) do
    UserIdentity
    |> where(user_id: ^user.id)
    |> where(active: true)
    |> Repo.all()
  end

  @doc """
  Gets a single user_identity.

  Raises `Ecto.NoResultsError` if the User identity does not exist.

  ## Examples

      iex> get_user_identity!(123)
      %UserIdentity{}

      iex> get_user_identity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_identity!(id), do: Repo.get!(UserIdentity, id)

  @doc """
  Creates a user_identity.

  ## Examples

      iex> create_user_identity(%{field: value})
      {:ok, %UserIdentity{}}

      iex> create_user_identity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_identity(attrs \\ %{}) do
    %UserIdentity{}
    |> UserIdentity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_identity.

  ## Examples

      iex> update_user_identity(user_identity, %{field: new_value})
      {:ok, %UserIdentity{}}

      iex> update_user_identity(user_identity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_identity(%UserIdentity{} = user_identity, attrs) do
    user_identity
    |> UserIdentity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_identity.

  ## Examples

      iex> delete_user_identity(user_identity)
      {:ok, %UserIdentity{}}

      iex> delete_user_identity(user_identity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_identity(%UserIdentity{} = user_identity) do
    Repo.delete(user_identity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_identity changes.

  ## Examples

      iex> change_user_identity(user_identity)
      %Ecto.Changeset{data: %UserIdentity{}}

  """
  def change_user_identity(%UserIdentity{} = user_identity, attrs \\ %{}) do
    UserIdentity.changeset(user_identity, attrs)
  end
end
