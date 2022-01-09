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

  def fetch_motd(conn, _opts) do
    motd = case Accounts.get_user() do
      nil -> ""

      user ->
        if String.length(user.motd) > 0 do
          user.motd
          |> String.split("\n")
          |> IO.inspect()
          |> Enum.take_random(1)
          |> List.first()
        else ""
        end
    end

    assign(conn, :motd, motd)
  end
end
