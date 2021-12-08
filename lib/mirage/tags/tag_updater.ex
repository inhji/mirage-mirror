defmodule Mirage.Tags.TagUpdater do
  @doc """
  Updates the tags for the given schema

  ## Examples

      iex> update_tags(note, "foo,bar")

  """
  def update_tags(schema, new_tags) when is_binary(new_tags) do
    old_tags = get_tags(schema) |> split_tags()
    new_tags = new_tags |> split_tags()

    schema
    |> add_tags(new_tags -- old_tags)
    |> remove_tags(old_tags -- new_tags)
  end

  defp get_tags(%{tags: tags} = _schema) do
    tags |> Enum.map_join(", ", & &1.title)
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
      case Mirage.Tags.get_tag(slug) do
        nil -> Mirage.Tags.create_tag(%{title: tag})
        tag -> {:ok, tag}
      end

    case schema do
      %Mirage.Notes.Note{} ->
        attrs = %{
          note_id: schema_id,
          tag_id: tag.id
        }

        %Mirage.Notes.NoteTag{}
        |> Mirage.Notes.NoteTag.changeset(attrs)
        |> Mirage.Repo.insert()
    end
  end

  defp remove_tags(schema, tags) do
    Enum.each(tags, &remove_tag(schema, &1))
    schema
  end

  defp remove_tag(schema, _tag) do
    schema
  end
end
