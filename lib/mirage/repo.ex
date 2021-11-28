defmodule Mirage.Repo do
  use Ecto.Repo,
    otp_app: :mirage,
    adapter: Ecto.Adapters.Postgres
end
