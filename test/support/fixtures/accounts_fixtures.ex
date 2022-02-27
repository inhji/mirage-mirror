defmodule Mirage.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mirage.Accounts` context.
  """

  import Mirage.Factory

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"
  def valid_user_handle, do: "myawesomeinternethandle"

  def valid_user_attributes(attrs \\ %{}) do
    list = insert(:list)

    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      handle: valid_user_handle(),
      pub_key: "Some Public Key",
      priv_key: "Some Private Key",
      microblog_list_id: list.id,
      bookmark_list_id: list.id,
      journal_list_id: list.id,
      like_list_id: list.id
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Mirage.Accounts.register_user()

    {:ok, user} = Mirage.Accounts.update_user_profile(user, valid_user_attributes())
    {:ok, user} = Mirage.Accounts.update_user_settings(user, valid_user_attributes())

    user
  end

  def create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
