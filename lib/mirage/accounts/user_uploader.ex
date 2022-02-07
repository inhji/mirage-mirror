defmodule Mirage.Accounts.UserUploader do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :square]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png)
    |> Enum.member?(Path.extname(file.file_name) |> String.downcase())
  end

  def transform(:square, _) do
    {:convert, "-thumbnail 500x500^ -colors 24 -dither FloydSteinberg -format png", :png}
  end

  # Override the persisted filenames:
  def filename(version, {_file, _scope}) do
    "avatar-#{version}"
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, _scope}) do
    "uploads/avatar"
  end
end
