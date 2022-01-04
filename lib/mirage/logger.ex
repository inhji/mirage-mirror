defmodule Mirage.Logger do
  require Logger

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
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def clear_logs() do
    Repo.delete_all(Log)
  end

  def log(message, level, metadata \\ %{}) do
    args = %{
      message: message,
      level: level,
      metadata: metadata
    }

    log = Log.changeset(%Log{}, args)

    case Repo.insert(log) do
      {:ok, log} ->
        Logger.info("Log Message: #{inspect(args, pretty: true)}")
        {:ok, log}

      error ->
        Logger.warn("Error while logging: #{inspect(error, pretty: true)}")
        error
    end
  end

  def info(message, metadata \\ %{}) do
    log(message, :info, metadata)
  end

  def error(message, metadata \\ %{}) do
    log(message, :error, metadata)
  end
end
