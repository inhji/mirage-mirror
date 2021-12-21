defmodule MirageWeb.Admin.NoteView do
  use MirageWeb, :view

  def tags_to_string(tags) when is_list(tags) do
    Enum.map_join(tags, ", ", fn tag -> tag.title end)
  end
end
