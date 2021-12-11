defmodule Mirage.Tags.TagUpdater do
  alias Mirage.NoteTags
  alias Mirage.Tags
  alias Mirage.Notes.Note

  @doc """
  Updates the tags for the given schema

  ## Examples

      iex> update_tags(note, "foo,bar")

  """
  def update_tags(schema, new_tags) when is_binary(new_tags) do
    update_tags(schema, split_tags(new_tags))
  end

  def update_tags(%{tags: tags} = schema, new_tags) when is_list(new_tags) do
    old_tags = Enum.map(tags, fn tag -> tag.title end)

    schema
    |> add_tags(new_tags -- old_tags)
    |> remove_tags(old_tags -- new_tags)
  end

  defp split_tags(tags_string) when is_binary(tags_string) do
    tags_string
    |> String.split(",")
    |> Enum.map(&String.trim/1)
  end

  defp add_tags(schema, tags) do
    Enum.each(tags, &add_tag(schema, &1))
    schema
  end

  defp add_tag(%{id: schema_id} = schema, tag) when is_binary(tag) do
    slug = Slugger.slugify(tag)

    {:ok, tag} =
      case Tags.get_tag(slug) do
        nil ->
          Tags.create_tag(%{title: tag})

        tag ->
          {:ok, tag}
      end

    case schema do
      %Note{} ->
        attrs = %{
          note_id: schema_id,
          tag_id: tag.id
        }

        {:ok, _note_tag} = NoteTags.create_note_tag(attrs)
    end
  end

  defp remove_tags(schema, tags) do
    Enum.each(tags, &remove_tag(schema, &1))
    schema
  end

  defp remove_tag(schema, tag) do
    slug = Slugger.slugify(tag)

    if tag = Tags.get_tag(slug) do
      case schema do
        %Note{} ->
          attrs = %{tag_id: tag.id, note_id: schema.id}
          note_tag = NoteTags.get_note_tag!(attrs)

          {:ok, _} = NoteTags.delete_note_tag(note_tag)
      end
    else
      nil
    end
  end
end
