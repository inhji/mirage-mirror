defmodule Mirage.ListsTest do
  use Mirage.DataCase

  alias Mirage.Lists

  describe "lists" do
    alias Mirage.Lists.List

    import Mirage.ListsFixtures

    @invalid_attrs %{
      content: nil,
      content_html: nil,
      display_type: nil,
      published_at: nil,
      slug: nil,
      title: nil,
      viewed_at: nil,
      views: nil
    }

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Lists.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Lists.get_list!(list.slug) == list
    end

    test "create_list/1 with valid data creates a list" do
      valid_attrs = %{
        content: "some content",
        title: "some title"
      }

      assert {:ok, %List{} = list} = Lists.create_list(valid_attrs)
      assert list.content == "some content"
      assert list.slug == "some-title"
      assert list.title == "some title"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lists.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()

      update_attrs = %{
        title: "some updated title",
        content: "some updated content",
        slug: "some updated slug"
      }

      assert {:ok, %List{} = list} = Lists.update_list(list, update_attrs)
      assert list.content == "some updated content"
      assert list.slug == "some-title"
      assert list.title == "some updated title"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Lists.update_list(list, @invalid_attrs)
      assert list == Lists.get_list!(list.slug)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Lists.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Lists.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Lists.change_list(list)
    end
  end
end
