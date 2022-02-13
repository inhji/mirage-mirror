defmodule Mirage.Notes.NoteUploader do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :horiz, :vert]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png)
    |> Enum.member?(Path.extname(file.file_name) |> String.downcase())
  end

  def transform(:horiz, _) do
    {:convert,
     "-thumbnail 720x360^ -gravity center -extent 720x360 -colors 24 -dither FloydSteinberg -format png",
     :png}
  end

  def transform(:vert, _) do
    {:convert,
     "-thumbnail 360x720^ -gravity center -extent 360x720 -colors 24 -dither FloydSteinberg -format png",
     :png}
  end

  # Override the persisted filenames:
  def filename(version, {_file, _scope}) do
    version
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    "uploads/notes/#{scope.slug}"
  end
end
