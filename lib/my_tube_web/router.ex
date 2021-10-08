defmodule MyTubeWeb.Router do
  use MyTubeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end



  scope "/", MyTubeWeb do
    pipe_through [:browser, :authenticate_user]

    get "/", PageController, :index
    get "/test", PageController, :test

    resources "/users", UserController, only: [
      :new, :create, :show, :edit, :update, :delete
    ]

    get "/login", SessionController, :login
    post "/login", SessionController, :create
    delete "/logout", SessionController, :logout

    get "/search", SearchController, :index
    post "/search", SearchController, :search

    resources "/uploads", UploadController,
    only: [:new, :create, :show, :edit, :update, :delete] do
      resources "/comments", CommentController,
      only: [:create]
    end
  end


  ## authenticate user
  defp authenticate_user(conn, _params) do

    user =
    case get_session(conn, :user_id) do
      nil -> nil
      id -> MyTube.Query.User.get_user!(id)
    end

    conn
    |> assign(:current_user, user)
  end



  # Other scopes may use custom stacks.
  # scope "/api", MyTubeWeb do
  #   pipe_through :api
  # end

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
      live_dashboard "/dashboard", metrics: MyTubeWeb.Telemetry
    end
  end
end
