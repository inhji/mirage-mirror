defmodule Mirage.TagsTest do
  use Mirage.DataCase

  import Mirage.TagsFixtures
  alias Mirage.Tags
  alias Mirage.Tags.Tag

  describe "tags" do
    @invalid_attrs %{
      content: nil,
      content_html: nil,
      icon: nil,
      regex: nil,
      slug: nil,
      title: nil
    }

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Tags.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Tags.get_tag!(tag.slug) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{
        content: "some content",
        icon: "some icon",
        regex: "some regex",
        title: "some title"
      }

      assert {:ok, %Tag{} = tag} = Tags.create_tag(valid_attrs)
      assert tag.content == "some content"
      assert tag.icon == "some icon"
      assert tag.regex == "some regex"
      assert tag.title == "some title"
      assert tag.slug == "some-title"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tags.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()

      update_attrs = %{
        content: "some updated content",
        icon: "some updated icon",
        regex: "some updated regex",
        title: "some updated title"
      }

      assert {:ok, %Tag{} = tag} = Tags.update_tag(tag, update_attrs)
      assert tag.content == "some updated content"
      assert tag.icon == "some updated icon"
      assert tag.regex == "some updated regex"
      assert tag.title == "some updated title"
      assert tag.slug == "some-title"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Tags.update_tag(tag, @invalid_attrs)
      assert tag == Tags.get_tag!(tag.slug)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Tags.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Tags.get_tag!(tag.slug) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Tags.change_tag(tag)
    end
  end
end
