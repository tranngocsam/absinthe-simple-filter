defmodule DemoWeb.UserResolvers do
  def resolve_create_user(_parent, args, resolution) do
    current_user = resolution.context.current_user

    if current_user do
      {:error, %{message: "Require logout"}}
    else
      {status, user} = Demo.Accounts.create_user(args)

      if status == :ok do
        {:ok, %{id: session_id}} = Demo.Sessions.create_session(%{user_id: user.id})
        token = DemoWeb.Auth.Token.sign(%{session_id: session_id})
        {:ok, %{token: token}}
      else
        errors = Demo.Utils.full_messages(user.errors)
        {:error, %{message: "error", details: errors}}
      end
    end
  end

  def resolve_login(_parent, args, resolution) do
    current_user = resolution.context.current_user

    if current_user do
      {:error, %{message: "Require logout"}}
    else
      login_params = %{"email"=> args[:email], "password" => args[:password]}
      case Phauxth.Login.verify(login_params) do
        {:ok, user} ->
          {:ok, %{id: session_id}} = Demo.Sessions.create_session(%{user_id: user.id})
          token = DemoWeb.Auth.Token.sign(%{session_id: session_id})
          {:ok, %{token: token}}
        {:error, message} ->
          {:error, message}
      end
    end
  end
end