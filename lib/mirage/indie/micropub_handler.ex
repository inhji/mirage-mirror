defmodule Mirage.Indie.MicropubHandler do
  require Logger
  alias MirageWeb.Router.Helpers, as: Routes
  alias Mirage.Indie.{Attributes, Token}

  @syndication_targets Application.compile_env!(:mirage, [:indie, :supported_targets])

  @behaviour PlugMicropub.HandlerBehaviour

  @impl true
  def handle_create(_type, properties, access_token) do
    Logger.info("plug_micropub/handle_create")

    with :ok <- Token.verify(access_token, "create", hostname()),
         {:ok, post_type} <- Attributes.get_post_type(properties) do
      create_post(post_type, properties)
    else
      error ->
        IO.inspect(error)
        {:error, :unhandled_error}
    end
  end

  def create_post(:note, props) do
    title = DateTime.to_unix(DateTime.utc_now())
    content = Attributes.get_content(props)
    tags = Attributes.get_tags(props) |> Enum.join(",")
    user = Mirage.Accounts.get_user()
    reply_to = Attributes.get_reply_to(props)

    attrs = %{
      "title" => title,
      "content" => content,
      "user_id" => user.id,
      "tags_string" => tags,
      "in_reply_to" => reply_to
    }

    case Mirage.Notes.create_note_with_hooks(attrs) do
      {:ok, note} ->
        Logger.info("Note created!")
        {:ok, :created, Routes.note_url(MirageWeb.Endpoint, :show, note)}

      {:error, error} ->
        Logger.error(error)
        {:error, :internal_server_error}
    end
  end

  def create_post(:bookmark, props) do
    title = Attributes.get_title(props)
    content = Attributes.get_content(props)

    bookmark_of = Attributes.get_bookmarked_url(props)
    repost_of = Attributes.get_reposted_url(props)
    like_of = Attributes.get_liked_url(props)

    url =
      [repost_of, like_of, bookmark_of]
      |> Enum.filter(fn url -> not is_nil(url) end)
      |> List.first()

    tags = Attributes.get_tags(props) |> Enum.join(",")
    user = Mirage.Accounts.get_user()

    attrs = %{
      "title" => title,
      "content" => content || title,
      "url" => url,
      "user_id" => user.id,
      "tags_string" => tags,
      "repost_of" => repost_of,
      "like_of" => like_of,
      "bookmark_of" => bookmark_of
    }

    case Mirage.Bookmarks.create_bookmark_with_hooks(attrs) do
      {:ok, bookmark} ->
        {:ok, :created, Routes.bookmark_url(MirageWeb.Endpoint, :show, bookmark)}

      {:error, error} ->
        Logger.error(error)
        {:error, :internal_server_error}
    end
  end

  @impl true
  def handle_syndicate_to_query(access_token) do
    Logger.info("plug_micropub/handle_syndicate_to_query")

    case Token.verify(access_token, nil, hostname()) do
      :ok ->
        {:ok,
         %{
           "syndicate-to" => @syndication_targets
         }}

      error ->
        IO.inspect(error)
        {:error, :unhandled_error}
    end
  end

  @impl true
  def handle_config_query(access_token) do
    Logger.info("plug_micropub/handle_config_query")

    case Token.verify(access_token, nil, hostname()) do
      :ok ->
        {:ok,
         %{
           "syndicate-to" => @syndication_targets
         }}

      error ->
        IO.inspect(error)
        {:error, :unhandled_error}
    end
  end

  @impl true
  def handle_update(_, _, _, _, _) do
    {:error, :unsupported_method}
  end

  @impl true
  def handle_delete(_url, _access_token) do
    {:error, :unsupported_method}
  end

  @impl true
  def handle_undelete(_url, _access_token) do
    {:error, :unsupported_method}
  end

  @impl true
  def handle_source_query(_url, _filter_properties, _access_token) do
    {:error, :unsupported_method}
  end

  @impl true
  def handle_media(_files, _access_token) do
    {:error, :unsupported_method}
  end

  defp hostname do
    MirageWeb.Endpoint
    |> Routes.url()
    |> URI.parse()
    |> Map.get(:host)
  end
end
