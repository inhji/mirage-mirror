defmodule Mirage.Jobs do
  @moduledoc """
  The Lists context.
  """

  import Ecto.Query, warn: false
  alias Mirage.Repo
  alias Oban.Job

  def list_jobs() do
    Job
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end
end
