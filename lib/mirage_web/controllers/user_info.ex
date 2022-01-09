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
    motd =
      case Accounts.get_user() do
        nil -> ""
        user -> get_random_motd(user.motd)
      end

    assign(conn, :motd, motd)
  end

  defp get_random_motd(nil), do: ""
  defp get_random_motd(""), do: ""

  defp get_random_motd(motd_string) do
    motd_string
    |> String.split("\n")
    |> Enum.take_random(1)
    |> List.first()
  end
end
