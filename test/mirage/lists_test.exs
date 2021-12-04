defmodule Mirage.ListsTest do
  use Mirage.DataCase

  alias Mirage.Lists

  describe "lists" do
    alias Mirage.Lists.List

    import Mirage.ListsFixtures

    @invalid_attrs %{content: nil, content_html: nil, display_type: nil, published_at: nil, slug: nil, title: nil, viewed_at: nil, views: nil}

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Lists.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Lists.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      valid_attrs = %{content: "some content", content_html: "some content_html", display_type: :list, published_at: ~N[2021-12-03 08:47:00], slug: "some slug", title: "some title", viewed_at: ~N[2021-12-03 08:47:00], views: 42}

      assert {:ok, %List{} = list} = Lists.create_list(valid_attrs)
      assert list.content == "some content"
      assert list.content_html == "some content_html"
      assert list.display_type == :list
      assert list.published_at == ~N[2021-12-03 08:47:00]
      assert list.slug == "some slug"
      assert list.title == "some title"
      assert list.viewed_at == ~N[2021-12-03 08:47:00]
      assert list.views == 42
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lists.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      update_attrs = %{content: "some updated content", content_html: "some updated content_html", display_type: :gallery, published_at: ~N[2021-12-04 08:47:00], slug: "some updated slug", title: "some updated title", viewed_at: ~N[2021-12-04 08:47:00], views: 43}

      assert {:ok, %List{} = list} = Lists.update_list(list, update_attrs)
      assert list.content == "some updated content"
      assert list.content_html == "some updated content_html"
      assert list.display_type == :gallery
      assert list.published_at == ~N[2021-12-04 08:47:00]
      assert list.slug == "some updated slug"
      assert list.title == "some updated title"
      assert list.viewed_at == ~N[2021-12-04 08:47:00]
      assert list.views == 43
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Lists.update_list(list, @invalid_attrs)
      assert list == Lists.get_list!(list.id)
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
