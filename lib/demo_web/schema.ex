defmodule DemoWeb.Schema do
  use Absinthe.Schema

  import_types Demo.Schema.DataTypes
  import Ecto.Query

  query do
    @desc "Get a list of users"
    field :users, :user_results do
      arg(:filters, :user_filter_input)
      arg(:pagination, :asf_pagination_input)
      resolve fn _parent, args, resolution ->
        if resolution.context.current_user do
          pagination = Demo.Accounts.list_users(args[:filters], args[:pagination])
          result = %{
            data: pagination.entries,
            meta: %{
              total: pagination.total_entries,
              page_number: pagination.page_number,
              per_page: pagination.per_page
            }
          }
          {:ok, result}
        else
          {:error, message: "Unauthorized", code: 403}
        end
      end
    end

    @desc "Get a list of user profiles"
    field :user_profiles, :user_profile_results do
      arg(:filters, :user_profile_filter_input)
      arg(:pagination, :asf_pagination_input)
      resolve fn _parent, args, resolution ->
        if resolution.context.current_user do
          pagination = Demo.Accounts.list_user_profiles(args[:filters], args[:pagination])
          result = %{
            data: pagination.entries,
            meta: %{
              total: pagination.total_entries,
              page_number: pagination.page_number,
              per_page: pagination.per_page
            }
          }
          {:ok, result}
        else
          {:error, message: "Unauthorized", code: 403}
        end
      end
    end
  end

  mutation do
    @desc "Register user"
    field :create_user, type: :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve fn _parent, args, _resolution ->
        {status, user} = Demo.Accounts.create_user(args)

        if status == :ok do
          {:ok, user}
        else
          errors = for {key, {message, _}} <- user.errors do
            "#{key} #{message}"
          end

          {:error, %{message: "error", details: errors}}
        end
      end
    end

    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
  
      resolve fn _parent, args, _resolution ->
        login_params = %{"email"=> args.email, "password" => args.password}
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

    @desc "Create or update user profile of the current user"
    field :update_user_profile, type: :user_profile_custom_fields do
      arg(:name, :string)
      arg(:dob, :date)
      arg(:address, :asf_json)

      resolve fn _parent, args, resolution ->
        if resolution.context.current_user do
          up = Demo.Repo.one(Ecto.assoc(resolution.context.current_user, :user_profile))

          if up do
            {status, user_profile} = Demo.Accounts.update_user_profile(up, args)

            if status == :ok do
              {:ok, user_profile}
            else
              errors = Demo.Utils.full_messages(user_profile.errors)
              {:error, %{message: "error", details: errors}}
            end
          else
            user_id = resolution.context.current_user.id
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
  end
end