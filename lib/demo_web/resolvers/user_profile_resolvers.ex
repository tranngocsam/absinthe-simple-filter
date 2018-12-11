defmodule DemoWeb.UserProfileResolvers do
  def resolve_user_profile(_parent, _args, resolution) do
    current_user = resolution.context.current_user
    
    if current_user do
      result = Ecto.assoc(current_user, :user_profile)
        |> Demo.Repo.one
        |> Demo.Repo.preload(:skills)
      
      {:ok, result}
    else
      {:error, message: "Unauthorized", code: 403}
    end
  end

  def resolve_update_user_profile(_parent, args, resolution) do
    current_user = resolution.context.current_user
    if current_user do
      up = Demo.Repo.one(Ecto.assoc(current_user, :user_profile))

      if up do
        {status, user_profile} = Demo.Accounts.update_user_profile(up, args)

        if status == :ok do
          {:ok, user_profile}
        else
          errors = Demo.Utils.full_messages(user_profile.errors)
          {:error, %{message: "error", details: errors}}
        end
      else
        user_id = current_user.id
        {status, user_profile} = Demo.Accounts.create_user_profile(Map.put(args, :user_id, user_id))

        if status == :ok do
          {:ok, user_profile}
        else
          errors = Demo.Utils.full_messages(user_profile.errors)
          {:error, %{message: "error", details: errors}}
        end
      end
    else
      {:error, message: "Unauthorized", code: 403}
    end
  end
end