defmodule Mirage.Logger.Log do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "logs" do
    field :message, :string
    field :level, Ecto.Enum, values: [:trace, :debug, :info, :warn, :error, :fatal]
    field :metadata, :map
    field :reference_id, :string

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:message, :level, :metadata, :reference_id])
    |> validate_required([:message, :level, :metadata])
  end
end
