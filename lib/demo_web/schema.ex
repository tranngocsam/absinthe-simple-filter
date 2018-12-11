defmodule DemoWeb.Schema do
  use Absinthe.Schema

  import_types Demo.Schema.DataTypes
  import_types Absinthe.Plug.Types
  import Ecto.Query

  query do
    @desc "Get current user's profile"
    field :user_profile, :user_profile do
      resolve &DemoWeb.UserProfileResolvers.resolve_user_profile/3
    end
  end

  mutation do
    @desc "Register user"
    field :create_user, type: :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve &DemoWeb.UserResolvers.resolve_create_user/3
    end

    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
  
      resolve &DemoWeb.UserResolvers.resolve_login/3
    end

    @desc "Create or update user profile of the current user"
    field :update_user_profile, type: :user_profile_custom_fields do
      arg(:name, :string)
      arg(:dob, :date)
      arg(:address, :asf_json)
      arg(:image, :upload)

      resolve &DemoWeb.UserProfileResolvers.resolve_update_user_profile/3
    end
  end
end