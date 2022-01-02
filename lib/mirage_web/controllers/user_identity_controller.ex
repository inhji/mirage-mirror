defmodule MirageWeb.UserIdentityController do
  use MirageWeb, :controller

  alias Mirage.Identities
  alias Mirage.Identities.UserIdentity

  def new(conn, _params) do
    changeset = Identities.change_user_identity(%UserIdentity{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user_identity" => user_identity_params}) do
    case Identities.create_user_identity(user_identity_params) do
      {:ok, user_identity} ->
        conn
        |> put_flash(:info, "User identity created successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user_identity = Identities.get_user_identity!(id)
    render(conn, "show.html", user_identity: user_identity)
  end

  def edit(conn, %{"id" => id}) do
    user_identity = Identities.get_user_identity!(id)
    changeset = Identities.change_user_identity(user_identity)
    render(conn, "edit.html", user_identity: user_identity, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user_identity" => user_identity_params}) do
    user_identity = Identities.get_user_identity!(id)

    case Identities.update_user_identity(user_identity, user_identity_params) do
      {:ok, user_identity} ->
        conn
        |> put_flash(:info, "User identity updated successfully.")
        |> redirect(to: Routes.user_identity_path(conn, :show, user_identity))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user_identity: user_identity, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_identity = Identities.get_user_identity!(id)
    {:ok, _user_identity} = Identities.delete_user_identity(user_identity)

    conn
    |> put_flash(:info, "User identity deleted successfully.")
    |> redirect(to: Routes.user_settings_path(conn, :edit))
  end
end
