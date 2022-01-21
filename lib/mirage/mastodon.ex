defmodule Mirage.Mastodon do
  use Tesla

  @host Application.compile_env!(:mirage, [:mastodon, :instance_host])
  @id Application.compile_env!(:mirage, [:mastodon, :client_id])
  @secret Application.compile_env!(:mirage, [:mastodon, :client_secret])
  @redirect_uri "urn:ietf:wg:oauth:2.0:oob"
  @scopes "read write"

  defp client() do
    middleware = [
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BaseUrl, "https://#{@host}"},
      {Tesla.Middleware.Headers, [{"User-Agent", Mirage.user_agent()}]}
    ]

    Tesla.client(middleware)
  end

  def authorize_url() do
    %URI{
      scheme: "https",
      host: @host,
      path: "/oauth/authorize",
      query:
        URI.encode_query(%{
          response_type: "code",
          client_id: @id,
          redirect_uri: @redirect_uri,
          scope: @scopes
        })
    }
    |> URI.to_string()
  end

  def get_token(auth_code) do
    post(
      client(),
      "/oauth/token",
      %{
        grant_type: "authorization_code",
        client_id: @id,
        client_secret: @secret,
        redirect_uri: @redirect_uri,
        scope: @scopes,
        code: auth_code
      }
    )
  end
end
