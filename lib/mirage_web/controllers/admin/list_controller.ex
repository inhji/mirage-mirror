defmodule MirageWeb.Admin.ListController do
  use MirageWeb, :controller

  alias Mirage.Lists
  alias Mirage.Lists.List

  def index(conn, _params) do
    lists = Lists.list_lists()
    render(conn, "index.html", lists: lists, page_title: "Lists")
  end

  def new(conn, _params) do
    changeset = Lists.change_list(%List{})
    render(conn, "new.html", changeset: changeset, page_title: "New List")
  end

  def create(conn, %{"list" => list_params}) do
    case Lists.create_list(list_params) do
      {:ok, list} ->
        conn
        |> put_flash(:info, "List created successfully.")
        |> redirect(to: Routes.admin_list_path(conn, :show, list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, page_title: "New List")
    end
  end

  def show(conn, %{"id" => id}) do
    list = Lists.get_list!(id)
    render(conn, "show.html", list: list, page_title: list.title)
  end

  def edit(conn, %{"id" => id}) do
    list = Lists.get_list!(id)
    changeset = Lists.change_list(list)
    render(conn, "edit.html", list: list, changeset: changeset, page_title: "Edit List")
  end

  def update(conn, %{"id" => id, "list" => list_params}) do
    list = Lists.get_list!(id)

    case Lists.update_list(list, list_params) do
      {:ok, list} ->
        conn
        |> put_flash(:info, "List updated successfully.")
        |> redirect(to: Routes.admin_list_path(conn, :show, list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", list: list, changeset: changeset, page_title: "Edit List")
    end
  end

  def publish(conn, %{"id" => id}) do
    list = Lists.get_list!(id)

    case Lists.publish_list(list) do
      {:ok, list} ->
        conn
        |> put_flash(:info, "List published successfully.")
        |> redirect(to: Routes.admin_list_path(conn, :show, list))

      {:error, %Ecto.Changeset{} = _changeset} ->
        render(conn, "show.html", list: list)
    end
  end

  def unpublish(conn, %{"id" => id}) do
    list = Lists.get_list!(id)

    case Lists.unpublish_list(list) do
      {:ok, list} ->
        conn
        |> put_flash(:info, "List unpublished successfully.")
        |> redirect(to: Routes.admin_list_path(conn, :show, list))

      {:error, %Ecto.Changeset{} = _changeset} ->
        render(conn, "show.html", list: list)
    end
  end

  def delete(conn, %{"id" => id}) do
    list = Lists.get_list!(id)
    {:ok, _list} = Lists.delete_list(list)

    conn
    |> put_flash(:info, "List deleted successfully.")
    |> redirect(to: Routes.admin_list_path(conn, :index))
  end
end
