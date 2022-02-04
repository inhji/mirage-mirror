defmodule Mirage.Mastodon do
  require Logger

  @redirect_uri "urn:ietf:wg:oauth:2.0:oob"
  @scope "read write"
  @default_visibility "unlisted"

  def get_bookmarks(token) do
    OAuth2.Client.get(client(token), "/api/v1/bookmarks")
  end

  def post_status(token, status_text) do
    do_post_status(token, %{
      status: status_text,
      visibility: @default_visibility
    })
  end

  def post_status_with_cw(token, status_text, content_warning) do
    do_post_status(token, %{
      status: status_text,
      visibility: @default_visibility,
      sensitive: true,
      spoiler_text: content_warning
    })
  end

  defp do_post_status(token, params) do
    mastodon_enabled = get_config(:enabled)

    if mastodon_enabled do
      Logger.info("Sending post to Mastodon..")

      Mirage.Logger.info("Sending request to Mastodon.", params)

      token
      |> client()
      |> OAuth2.Client.post("/api/v1/statuses", params)
      |> handle_response()
    else
      Logger.warn("Mastodon was disabled by config.")
    end
  end

  defp handle_response({:ok, %OAuth2.Response{body: body, status_code: 200}}) do
    Logger.info("Request successful!")
    Logger.info("Response Body: #{inspect(body)}")

    Mirage.Logger.info("Request to Mastodon sent!", %{
      status: 200,
      body: body
    })
  end

  defp handle_response({:ok, %OAuth2.Response{body: body, status_code: status}}) do
    Logger.info("Request ended with status #{status}!")
    Logger.info("Response Body: #{inspect(body)}")

    Mirage.Logger.info("Request to Mastodon sent!", %{
      status: status,
      body: body
    })
  end

  defp handle_response({:error, %OAuth2.Error{reason: reason}}) do
    Logger.warn("Request ended with error!")
    Logger.info("Response Error: #{inspect(reason)}")

    Mirage.Logger.info("Request to Mastodon sent!", %{
      reason: reason
    })
  end

  def client(token \\ nil) do
    host = get_config(:instance_url)
    id = get_config(:client_id)
    secret = get_config(:client_secret)

    client =
      OAuth2.Client.new(
        client_id: id,
        client_secret: secret,
        site: host,
        redirect_uri: @redirect_uri,
        params: %{
          scope: @scope
        },
        token: token
      )

    client =
      case token do
        nil ->
          client

        token ->
          Map.put(client, :token, OAuth2.AccessToken.new(token))
      end

    client
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  @doc """
  Returns the authorize url for the mastodon instance and client.

  Call open this url in the browser and login, then copy the code returned (auth_code).
  """
  def authorize_url() do
    OAuth2.Client.authorize_url!(client())
  end

  @doc """
  Requests a user_token for the current mastodon instance and client.

  Needs the auth_code from `authorize_url`.
  """
  def get_token(auth_code) do
    case OAuth2.Client.get_token(client(), code: auth_code) do
      {:ok, %OAuth2.Client{token: %OAuth2.AccessToken{access_token: access_token}}} ->
        Logger.info("get_token/1: Token successfully fetched!")
        {:ok, access_token}

      {:error,
       %OAuth2.Response{body: %{"error" => error, "error_description" => message}} = _response} ->
        {:error, %{error: error, message: message}}

      error ->
        Logger.warn("get_token/1: Token could not be fetched!")
        Logger.error(inspect(error))
        {:error, %{error: "Unknown Error", message: "Unknown"}}
    end
  end

  def save_token(user, token) do
    case Mirage.Accounts.generate_mastodon_user_token(user, token) do
      {:ok, token} ->
        {:ok, token}

      {:error,
       %OAuth2.Response{body: %{"error" => error, "error_description" => message}} = _response} ->
        {:error, %{error: error, message: message}}

      {:error, error} ->
        IO.inspect(error)
        {:error, %{error: 500, message: error}}
    end
  end

  defp get_config(key) do
    config = Application.get_env(:mirage, :mastodon)
    Keyword.get(config, key)
  end
end
