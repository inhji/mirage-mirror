defmodule MirageWeb.UserSettingsController do
  use MirageWeb, :controller

  alias Mirage.{Accounts, Identities}
  alias MirageWeb.UserAuth

  plug :assign_changesets
  plug :assign_form_data

  def edit(conn, _params) do
    render(conn, "edit.html", page_title: "Edit User")
  end

  def update(conn, %{"action" => "update_profile", "user" => user_params} = _params) do
    user = conn.assigns.current_user

    case Accounts.update_user_profile(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Your profile was updated.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", profile_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_settings", "user" => user_params} = _params) do
    user = conn.assigns.current_user

    case Accounts.update_user_settings(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Your settings were updated.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", settings_changeset: changeset)
    end
  end

  def update(conn, %{
        "action" => "update_mastodon_user_token",
        "mastodon_token" => %{"auth_code" => auth_code}
      }) do
    user = conn.assigns.current_user

    with {:ok, token} <- Mirage.Mastodon.get_token(auth_code),
         {:ok, _token} <- Mirage.Mastodon.save_token(user, token) do
      conn
      |> put_flash(:info, "Mastodon token '#{token}' was saved.")
      |> redirect(to: Routes.user_settings_path(conn, :edit))
    else
      {:error, %{error: error, message: message}} ->
        conn
        |> put_flash(:error, "#{error}: #{message}")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, _error} ->
        conn
        |> put_flash(:info, "Unknown error.")
        |> render("edit.html")
    end
  end

  def update(conn, %{"action" => "update_email"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.email,
          &Routes.user_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your email change has been sent to the new address."
        )
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))
    end
  end

  defp assign_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
    |> assign(:profile_changeset, Accounts.change_user_profile(user))
    |> assign(:settings_changeset, Accounts.change_user_settings(user))
    |> assign(:user_identities, Identities.list_user_identities(user))
  end

  defp assign_form_data(conn, _opts) do
    user = conn.assigns.current_user
    mastodon_token = Mirage.Accounts.get_mastodon_user_token(user)

    lists =
      Mirage.Lists.list_lists()
      |> Enum.map(&Mirage.Lists.for_select/1)

    conn
    |> assign(:lists, lists)
    |> assign(:user, user)
    |> assign(:mastodon_token, mastodon_token)
  end
end
