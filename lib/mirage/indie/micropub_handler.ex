defmodule Mirage.Indie.MicropubHandler do
  require Logger
  alias MirageWeb.Router.Helpers, as: Routes
  alias Mirage.Indie.{Attributes, Token, Micropub}

  @behaviour PlugMicropub.HandlerBehaviour

  @impl true
  def handle_create(_type, properties, access_token) do
    Logger.info("plug_micropub/handle_create")

    with :ok <- Token.verify(access_token, "create", hostname()),
         {:ok, post_type} <- Attributes.get_post_type(properties),
         {:ok, note} <- Micropub.create_post(properties, post_type) do
      Mirage.Logger.info("Created a new post from micropub", properties)
      {:ok, :created, Routes.note_url(MirageWeb.Endpoint, :show, note)}
    else
      error ->
        Logger.error("Error in handle_create: #{inspect(error)}")
        {:error, :unhandled_error}
    end
  end

  @impl true
  def handle_syndicate_to_query(access_token) do
    Logger.info("plug_micropub/handle_syndicate_to_query")

    case Token.verify(access_token, nil, hostname()) do
      :ok ->
        {:ok, %{"syndicate-to" => Micropub.get_syndication_response()}}

      error ->
        Logger.error("Error in handle_syndicate_to_query: #{inspect(error)}")
        {:error, :unhandled_error}
    end
  end

  @impl true
  def handle_channel_query(access_token) do
    Logger.info("plug_micropub/handle_channel_query")

    case Token.verify(access_token, nil, hostname()) do
      :ok ->
        {:ok, %{"channels" => Micropub.get_channel_response()}}

      error ->
        Logger.error("Error in handle_channel_query: #{inspect(error)}")
        {:error, :unhandled_error}
    end
  end

  @impl true
  def handle_config_query(access_token) do
    Logger.info("plug_micropub/handle_config_query")

    case Token.verify(access_token, nil, hostname()) do
      :ok ->
        Micropub.get_syndication_response()

        {:ok,
         %{
           "syndicate-to" => Micropub.get_syndication_response(),
           "channels" => Micropub.get_channel_response()
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
    {:error, :insufficient_scope}
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
end
