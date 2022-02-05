defmodule MirageWeb.Admin.NoteView do
  use MirageWeb, :view

  def tags_to_string(tags) when is_list(tags) do
    Enum.map_join(tags, ", ", fn tag -> tag.title end)
  end

  def targets_to_list(targets) do
    Enum.map(targets, fn target -> target.type end)
  end
end
