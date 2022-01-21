defmodule Mirage.Mastodon do
  use Tesla

  @redirect_uri "urn:ietf:wg:oauth:2.0:oob"
  @scope "read write"

  defp client() do
    host = get_config(:instance_host)

    middleware = [
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BaseUrl, "https://#{host}"},
      {Tesla.Middleware.Headers, [{"User-Agent", Mirage.user_agent()}]}
    ]

    Tesla.client(middleware)
  end

  def authorize_url() do
    host = get_config(:instance_host)
    id = get_config(:client_id)

    %URI{
      scheme: "https",
      host: host,
      path: "/oauth/authorize",
      query:
        URI.encode_query(%{
          response_type: "code",
          client_id: id,
          redirect_uri: @redirect_uri,
          scope: @scope
        })
    }
    |> URI.to_string()
  end

  def get_token(auth_code) do
    id = get_config(:client_id)
    secret = get_config(:client_secret)

    post(
      client(),
      "/oauth/token",
      %{
        grant_type: "authorization_code",
        client_id: id,
        client_secret: secret,
        code: auth_code,
        redirect_uri: @redirect_uri,
        scope: @scope
      }
    )
  end

  defp get_config(key) do
    config = Application.get_env(:mirage, :mastodon)
    Keyword.get(config, key)
  end
end
