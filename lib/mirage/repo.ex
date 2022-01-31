defmodule Mirage.Repo do
  use Ecto.Repo,
    otp_app: :mirage,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
