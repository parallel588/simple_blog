defmodule SimpleBlog.Web.Router do
  use SimpleBlog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :require_login do
    plug Guardian.Plug.EnsureAuthenticated,
      handler: SimpleBlog.GuardianErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SimpleBlog.Web do
    pipe_through [:browser, :browser_session] # Use the default browser stack

    get "/", PostController, :index
    get "/signup", RegistrationController, :new
    post "/signup", RegistrationController, :create
    get "/signin", SessionController, :new
    post "/signin", SessionController, :create

    resources "/posts", PostController, only: [:index, :show]

    get "/password/forget", PasswordController, :forget
    post "/password/reset", PasswordController, :reset
    get "/password/reset/:code", PasswordController, :confirm
    post "/password/reset/:code/confirm", PasswordController, :confirmed
  end

  scope "/", SimpleBlog.Web do
    pipe_through [:browser, :browser_session, :require_login]
    get "/logout", SessionController, :delete
    get "/account", AccountController, :edit
    put "/account", AccountController, :update
  end
  scope "/admin" , SimpleBlog.Web.Admin, as: :admin do
    pipe_through [:browser, :browser_session, :require_login]
    get "/", AccountController, :index
    resources "/users", AccountController
    resources "/blogs", PostController, as: :blog
  end
end
