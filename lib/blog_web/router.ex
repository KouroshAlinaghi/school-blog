defmodule BlogWeb.Router do
  use BlogWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: BlogWeb.AuthErrorHandler 
  end

  pipeline :not_authenticated do
    plug Pow.Plug.RequireNotAuthenticated,
      error_handler: BlogWeb.AuthErrorHandler 
  end
  
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BlogWeb do
    pipe_through [:browser, :not_authenticated]

    # USER MANAGEMENT
    get "/login", SessionController, :new
    post "/login", SessionController, :create
  end

  scope "/", BlogWeb do
    pipe_through [:browser, :protected]

    # POSTS
    resources "posts", PostController, only: [:new, :create, :edit, :update, :delete]

    # USER MANAGEMENT
    post "/signup", AdminController, :create
    get "/dashboard", AdminController, :show
    delete "/logout", SessionController, :delete
    delete "/users/:id", AdminController, :delete
  end

  scope "/", BlogWeb do
    pipe_through :browser

    resources "posts", PostController, only: [:show]
    get "/", PostController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BlogWeb do
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
      live_dashboard "/live-dashboard", metrics: BlogWeb.Telemetry
    end
  end
end
