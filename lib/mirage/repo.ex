defmodule Mirage.Repo do
  @moduledoc """
  Defines the repo for database access. Also sets the page_size for pagination.
  """

  use Ecto.Repo,
    otp_app: :mirage,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
