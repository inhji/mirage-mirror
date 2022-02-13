defmodule MirageWeb.Admin.NoteImageView do
  use MirageWeb, :view

  def image_link(image, version \\ :thumb) do
    Mirage.Notes.NoteUploader.url({image.filename, image}, version)
  end

  def image_markdown(image, version \\ :thumb) do
    "![#{image.title}](#{image_link(image, version)})"
  end
end
