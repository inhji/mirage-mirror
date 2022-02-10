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
      Mirage.Logger.info("Creating new post from micropub", properties)
      create_post(properties, post_type)
    else
      error ->
        Logger.error("Error in handle_create: #{inspect(error)}")
        {:error, :unhandled_error}
    end
  end

  def get_title(props, _post_type) do
    Attributes.get_title(props) || timestamp_as_string()
  end

  def get_content(props, post_type) do
    case post_type do
      :like ->
        "❤️"

      _ ->
        Attributes.get_content(props)
    end
  end

  def get_list(user, post_type) do
    case post_type do
      :like ->
        user.like_list_id

      :bookmark ->
        user.bookmark_list_id

      _ ->
        user.microblog_list_id
    end
  end

  def create_post(props, post_type) do
    user = Mirage.Accounts.get_user()
    title = get_title(props, post_type)
    content = get_content(props, post_type)
    list_id = get_list(user, post_type)

    tags = Attributes.get_tags(props) |> Enum.join(",")
    should_publish? = Attributes.is_published?(props)

    attrs = %{
      "title" => title,
      "content" => content,
      "user_id" => user.id,
      "list_id" => list_id,
      "tags_string" => tags,
      "read_of" => Attributes.get_read_url(props),
      "watch_of" => Attributes.get_watched_url(props),
      "listen_of" => Attributes.get_listened_url(props),
      "in_reply_to" => Attributes.get_reply_to(props),
      "repost_of" => Attributes.get_reposted_url(props),
      "like_of" => Attributes.get_liked_url(props),
      "bookmark_of" => Attributes.get_bookmarked_url(props),
      "syndication_targets" => Attributes.get_syndication_targets(props)
    }

    case Mirage.Notes.create_note_with_hooks(attrs) do
      {:ok, note} ->
        Logger.info("Note created!")
        maybe_publish(note, should_publish?)

        {:ok, :created, Routes.note_url(MirageWeb.Endpoint, :show, note)}

      {:error, error} ->
        Logger.error(error)
        {:error, :internal_server_error}
    end
  end

  def maybe_publish(note, should_publish?) do
    if should_publish? do
      Mirage.Notes.publish_note(note)
    end
  end

  # @impl true
  def handle_syndicate_to_query(access_token) do
    Logger.info("plug_micropub/handle_syndicate_to_query")

    case Token.verify(access_token, nil, hostname()) do
      :ok ->
        {:ok,
         %{
           "syndicate-to" => convert_targets(@syndication_targets)
         }}

      error ->
        Logger.error("Error in handle_syndicate_to_query: #{inspect(error)}")
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
           "syndicate-to" => convert_targets(@syndication_targets)
         }}

      error ->
        Logger.error("Error in handle_config_query: #{inspect(error)}")
        {:error, :unhandled_error}
    end
  end

  @impl true
  def handle_update(_, _, _, _, _) do
    {:error, :insufficient_scope}
  end

  @impl true
  def handle_delete(_url, _access_token) do
    {:error, :insufficient_scope}
  end

  @impl true
  def handle_undelete(_url, _access_token) do
    {:error, {:error, :insufficient_scope}}
  end

  @impl true
  def handle_source_query(_url, _filter_properties, _access_token) do
    {:error, :insufficient_scope}
  end

  @impl true
  def handle_media(_files, _access_token) do
    {:error, :insufficient_scope}
  end

  defp hostname do
    MirageWeb.Endpoint
    |> Routes.url()
    |> URI.parse()
    |> Map.get(:host)
  end

  defp timestamp_as_string() do
    DateTime.utc_now()
    |> DateTime.to_unix()
    |> to_string()
  end

  defp convert_targets(targets) do
    Enum.map(targets, fn target ->
      %{uid: target, name: target}
    end)
  end
end
