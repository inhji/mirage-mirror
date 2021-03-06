defmodule MirageWeb.Router do
  use MirageWeb, :router

  import MirageWeb.UserAuth
  import MirageWeb.UserInfo
  import MirageWeb.SiteInfo, only: [fetch_pages: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MirageWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :fetch_user_identities
    plug :fetch_indie_config
    plug :fetch_motd
    plug :fetch_custom_css
    plug :fetch_pages
    plug :fetch_lists
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :activity_pub do
    plug :accepts, ["json"]
  end

  scope "/", MirageWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/about", PageController, :about

    get "/follow", FeedController, :index
    get "/follow/:id", FeedController, :show

    get "/tags", TagController, :index
    get "/tagged-with/:id", TagController, :show

    get "/listed-in/:id", ListController, :show

    get "/bookmarks", NoteController, :index_bookmark
    get "/notes/:id", NoteController, :show

    get "/search", SearchController, :index
  end

  scope path: "/pub", as: :activity_pub, alias: MirageWeb.ActivityPub do
    pipe_through :activity_pub

    get "/actor", ActorController, :actor
    get "/inbox", ActorController, :inbox
  end

  scope path: "/admin", as: :admin, alias: MirageWeb.Admin do
    pipe_through [:browser, :require_authenticated_user]

    resources "/notes", NoteController
    get "/notes/:id/publish", NoteController, :publish
    get "/notes/:id/unpublish", NoteController, :unpublish
    resources "/notes/:id/images", NoteImageController, param: "image_id"

    resources "/lists", ListController
    get "/lists/:id/publish", ListController, :publish
    get "/lists/:id/unpublish", ListController, :unpublish

    resources "/tags", TagController

    get "/dashboard", DashboardController, :index
  end

  # Other scopes may use custom stacks.
  scope path: "/api/v1", as: :api_v1, alias: MirageWeb.API.V1 do
    pipe_through :api

    scope "/notes" do
      get "/search", NoteController, :search
    end
  end

  scope "/indie", as: :indie do
    forward "/micropub",
            PlugMicropub,
            handler: Mirage.Indie.MicropubHandler,
            json_encoder: Jason
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MirageWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", MirageWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", MirageWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    resources "/users/identities", UserIdentityController
  end

  scope "/", MirageWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
