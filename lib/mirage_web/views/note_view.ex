defmodule MirageWeb.NoteView do
  use MirageWeb, :view

  def tags_to_string(tags) when is_list(tags) do
    Enum.map_join(tags, ", ", fn tag -> tag.title end)
  end

  def datetime_for_display(datetime) do
    datetime
  end
end
