defmodule Mirage.Logger do
  import Ecto.Query, warn: false
  alias Mirage.Repo

  alias Mirage.Logger.Log

  def list_logs(opts \\ []) do
    opts = Enum.into(opts, %{})
    query = Log

    query =
      case(opts[:level]) do
        :info -> query |> where(level: :info)
        _ -> query
      end

    query
    |> Repo.all()
  end

  def clear_logs() do
    Repo.delete_all(Log)
  end

  def log(message, level, metadata \\ %{}) do
    %Log{}
    |> Log.changeset(%{
      message: message,
      level: level,
      metadata: metadata
    })
    |> Repo.insert()
  end

  def info(message, metadata \\ %{}) do
    log(message, :info, metadata)
  end
end
