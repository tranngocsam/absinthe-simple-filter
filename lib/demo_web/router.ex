defmodule DemoWeb.Router do
  use DemoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Phauxth.AuthenticateToken
  end

  pipeline :graphql do
    plug DemoWeb.Authentication, method: :token
  end

  scope "/api/v1", DemoWeb do
    pipe_through :api

    post "/sessions", SessionController, :create
    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/api" do
    pipe_through :graphql

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: DemoWeb.Schema, json_codec: Jason
  end
end
