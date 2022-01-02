defmodule Mirage.IdentitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mirage.Identities` context.
  """

  import Mirage.AccountsFixtures

  @doc """
  Generate a user_identity.
  """
  def user_identity_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, user_identity} =
      attrs
      |> Enum.into(%{
        active: true,
        name: "some name",
        public: true,
        rel: "some rel",
        value: "some value",
        user_id: user.id
      })
      |> Mirage.Identities.create_user_identity()

    user_identity
  end
end
