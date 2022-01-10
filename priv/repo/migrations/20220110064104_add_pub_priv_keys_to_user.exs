defmodule Mirage.Repo.Migrations.AddPubPrivKeysToUser do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :pub_key, :text
      add :priv_key, :text
    end

    {:ok, {priv, pub}} = RsaEx.generate_keypair()

    execute(fn -> repo().update_all("users", set: [pub_key: pub, priv_key: priv]) end)
  end

  def down do
    alter table(:users) do
      remove :pub_key
      remove :priv_key
    end
  end
end
