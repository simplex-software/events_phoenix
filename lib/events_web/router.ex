defmodule EventsWeb.Router do
  use EventsWeb, :router

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

  pipeline :browser_session do
    plug :browser
    plug EventsWeb.Plugs.Authentication
  end

  scope "/", EventsWeb do
    pipe_through :browser

    get "/users/login", UserController, :login
    post "/users/login", UserController, :session
  end

  scope "/", EventsWeb do
    pipe_through :browser_session # Use the default browser stack

    get "/", PageController, :index
    resources "/events", EventController
    resources "/users", UserController, only: [:new, :create]

  end


  # Other scopes may use custom stacks.
  # scope "/api", EventsWeb do
  #   pipe_through :api
  # end
end
