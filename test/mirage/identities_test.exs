defmodule Mirage.IdentitiesTest do
  use Mirage.DataCase

  import Mirage.IdentitiesFixtures
  import Mirage.AccountsFixtures

  alias Mirage.Identities
  alias Mirage.Identities.UserIdentity

  describe "users_identities" do
    @invalid_attrs %{active: nil, name: nil, public: nil, rel: nil, value: nil}

    setup :create_user

    test "list_users_identities/0 returns all users_identities", %{user: user} do
      user_identity = user_identity_fixture(%{user_id: user.id})
      assert Identities.list_user_identities(user) == [user_identity]
    end

    test "get_user_identity!/1 returns the user_identity with given id" do
      user_identity = user_identity_fixture()
      assert Identities.get_user_identity!(user_identity.id) == user_identity
    end

    test "create_user_identity/1 with valid data creates a user_identity", %{user: user} do
      valid_attrs = %{
        active: true,
        name: "some name",
        public: true,
        rel: "some rel",
        value: "some value",
        user_id: user.id
      }

      assert {:ok, %UserIdentity{} = user_identity} = Identities.create_user_identity(valid_attrs)
      assert user_identity.active == true
      assert user_identity.name == "some name"
      assert user_identity.public == true
      assert user_identity.rel == "some rel"
      assert user_identity.value == "some value"
    end

    test "create_user_identity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Identities.create_user_identity(@invalid_attrs)
    end

    test "update_user_identity/2 with valid data updates the user_identity" do
      user_identity = user_identity_fixture()

      update_attrs = %{
        active: false,
        name: "some updated name",
        public: false,
        rel: "some updated rel",
        value: "some updated value"
      }

      assert {:ok, %UserIdentity{} = user_identity} =
               Identities.update_user_identity(user_identity, update_attrs)

      assert user_identity.active == false
      assert user_identity.name == "some updated name"
      assert user_identity.public == false
      assert user_identity.rel == "some updated rel"
      assert user_identity.value == "some updated value"
    end

    test "update_user_identity/2 with invalid data returns error changeset" do
      user_identity = user_identity_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Identities.update_user_identity(user_identity, @invalid_attrs)

      assert user_identity == Identities.get_user_identity!(user_identity.id)
    end

    test "delete_user_identity/1 deletes the user_identity" do
      user_identity = user_identity_fixture()
      assert {:ok, %UserIdentity{}} = Identities.delete_user_identity(user_identity)
      assert_raise Ecto.NoResultsError, fn -> Identities.get_user_identity!(user_identity.id) end
    end

    test "change_user_identity/1 returns a user_identity changeset" do
      user_identity = user_identity_fixture()
      assert %Ecto.Changeset{} = Identities.change_user_identity(user_identity)
    end
  end
end
