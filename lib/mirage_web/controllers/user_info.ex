defmodule MirageWeb.UserInfo do
  import Plug.Conn

  alias Mirage.{Accounts, Identities}

  @doc """
  Assigns the identities of the user to the conn-object.
  Returns an empty list if no user is yet defined.
  """
  def fetch_user_identities(conn, _opts) do
    identities =
      case Accounts.get_user() do
        nil ->
          []

        user ->
          Identities.list_user_identities(user)
      end

    assign(conn, :identities, identities)
  end
end
