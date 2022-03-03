defmodule Mirage.Indie.Micropub do
	alias Mirage.Indie.{Attributes}
	require Logger

  @syndication_targets Application.compile_env!(:mirage, [:indie, :supported_targets])

  def create_post(props), do: create_post(props, :note)

  def create_post(props, post_type) do
    user = Mirage.Accounts.get_user()
    title = get_title(props, post_type)
    content = get_content(props, post_type)
	  list_id = get_list(props, user, post_type)
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

    Logger.info("Syndication Targets: #{Attributes.get_syndication_targets(props)}")

    case Mirage.Notes.create_note_with_hooks(attrs) do
      {:ok, note} ->
        Logger.info("Note created!")
        maybe_publish(note, should_publish?)

        {:ok, note}

      {:error, error} ->
        Logger.error(error)
        {:error, :internal_server_error}
    end
  end

  def maybe_publish(note, true), do: Mirage.Notes.publish_note(note)
  def maybe_publish(_note, false), do: nil

  def get_title(props, _post_type) do
    Attributes.get_title(props) ||
      DateTime.utc_now()
      |> DateTime.to_unix()
      |> to_string()
  end

  def get_content(props, post_type) do
    case post_type do
      :like ->
        "❤️"

      _ ->
        Attributes.get_content(props)
    end
  end

  def get_list(props, user, post_type) do
  	# channel is a list_id
  	channel = Attributes.get_channel(props)

  	if is_nil(channel) do
  		case post_type do
  		  :like ->
  		    user.like_list_id

  		  :bookmark ->
  		    user.bookmark_list_id

  		  _ ->
  		    user.microblog_list_id
  		end

  	else
  		channel

  	end  
  end

  def get_syndication_response() do
    {:ok, %{"syndicate-to" => convert_targets(@syndication_targets)}}
  end

  def get_channel_response() do
    lists = Mirage.Lists.list_published_lists()
    {:ok, %{"channel" => convert_lists(lists)}}
  end

  defp convert_lists(lists) do
    Enum.map(lists, fn list ->
      %{uid: list.id, name: list.title}
    end)
  end

  defp convert_targets(targets) do
    Enum.map(targets, fn target ->
      %{uid: target, name: target}
    end)
  end
end
