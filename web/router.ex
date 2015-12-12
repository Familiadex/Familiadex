defmodule Familiada.Router do
  use Familiada.Web, :router
  require Ueberauth


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

  pipeline :auth do
    plug Ueberauth, base_path: "/auth"
  end

  scope "/auth", Familiada do
    pipe_through [:browser, :auth]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  scope "/", Familiada do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :public
    get "/game", PageController, :game
    resources "/questions", QuestionController

    get "/register", RegistrationController, :new
    get "/register_fb", RegistrationController, :fb_new
    post "/register", RegistrationController, :create
    post "/register_fb", RegistrationController, :fb_create
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
    end

  # Other scopes may use custom stacks.
  # scope "/api", Familiada do
  #   pipe_through :api
  # end
end
