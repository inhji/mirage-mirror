defmodule MirageWeb.Admin.NoteView do
  use MirageWeb, :view

  def tags_to_string(tags) when is_list(tags) do
    tags
    |> Enum.map(fn tag -> tag.title end)
    |> Enum.join(", ")
  end
end
