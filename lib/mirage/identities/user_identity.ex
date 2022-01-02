defmodule Mirage.Identities.UserIdentity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users_identities" do
    field :name, :string
    field :value, :string
    field :rel, :string, default: "me"
    field :active, :boolean, default: false
    field :public, :boolean, default: false

    belongs_to :user, Mirage.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(user_identity, attrs) do
    user_identity
    |> cast(attrs, [:name, :value, :rel, :active, :public, :user_id])
    |> validate_required([:name, :value, :rel, :active, :public, :user_id])
  end
end
