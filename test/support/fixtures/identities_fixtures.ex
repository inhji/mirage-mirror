defmodule Mirage.IdentitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mirage.Identities` context.
  """

  @doc """
  Generate a user_identity.
  """
  def user_identity_fixture(attrs \\ %{}) do
    {:ok, user_identity} =
      attrs
      |> Enum.into(%{
        active: true,
        name: "some name",
        public: true,
        rel: "some rel",
        value: "some value"
      })
      |> Mirage.Identities.create_user_identity()

    user_identity
  end
end
