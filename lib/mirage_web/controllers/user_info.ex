defmodule MirageWeb.UserInfo do
  import Plug.Conn

  alias Mirage.{Accounts, Identities}

  @token_endpoint Application.compile_env!(:mirage, [:indie, :token_endpoint])
  @auth_endpoint Application.compile_env!(:mirage, [:indie, :auth_endpoint])

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

  def fetch_indie_config(conn, _opts) do
    assign(conn, :indie_config, %{
      token_endpoint: @token_endpoint,
      auth_endpoint: @auth_endpoint,
      micropub_endpoint: "/indie/micropub"
    })
  end

  def fetch_motd(conn, _opts) do
    motd =
      case Accounts.get_user() do
        nil -> ""
        user -> get_random_motd(user.motd)
      end

    assign(conn, :motd, motd)
  end

  def fetch_lists(conn, _opts) do
    lists =
      case Accounts.get_user() do
        nil -> nil
        user -> %{}
      end

    assign(conn, :lists, lists)
  end

  def fetch_custom_css(conn, _opts) do
    custom_css =
      case Accounts.get_user() do
        nil -> ""
        user -> user.custom_css
      end

    assign(conn, :custom_css, custom_css)
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
