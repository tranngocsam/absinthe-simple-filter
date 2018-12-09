defmodule Demo.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Demo.{Accounts.User, Accounts.UserProfile, Accounts.Company, Repo, Sessions, Sessions.Session}

  @doc """
  Returns the list of users.
  """
  # def list_users, do: Repo.all(User)
  def list_users(args \\ %{}, pagination_params \\ %{}) do
    args = args || %{}
    pagination_params = pagination_params || %{}

    fields = User.filter_fields
             |> Enum.map(fn(h)-> h[:field] end)
    query = from u in "users", select: map(u, ^fields)
    query = query |> User.asf_filter(args)

    Demo.Paginator.paginate(query, pagination_params)
  end

  @doc """
  Gets a single user.
  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a user based on the params.

  This is used by Phauxth to get user information.
  """
  def get_by(%{session_id: session_id}) do
    with %Session{user_id: user_id} <- Sessions.get_session(session_id),
         do: get_user(user_id)
  end

  def get_by(%{"email" => email}) do
    Repo.get_by(User, email: email)
  end

  def get_by(%{"user_id" => user_id}), do: Repo.get(User, user_id)

  @doc """
  Creates a user.
  """
  def create_user(attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  ################## USER PROFILE #######################

  @doc """
  Returns the list of users.
  """
  # def list_users, do: Repo.all(User)
  def list_user_profiles(args \\ %{}, pagination_params \\ %{}) do
    args = args || %{}
    pagination_params = pagination_params || %{}

    fields = UserProfile.filter_fields
             |> Enum.map(fn(h)-> h[:field] end)
    query = from u in "user_profiles", select: map(u, ^fields)
    query = query |> UserProfile.asf_filter(args)

    Demo.Paginator.paginate(query, pagination_params)
  end

  def create_user_profile(attrs) do
    %UserProfile{}
    |> UserProfile.changeset(attrs)
    |> Repo.insert()
  end

  def update_user_profile(%UserProfile{} = user_profile, attrs) do
    user_profile
    |> UserProfile.changeset(attrs)
    |> Repo.update()
  end

  def delete_user_profile(%UserProfile{} = user_profile) do
    Repo.delete(user_profile)
  end

  #################### COMPANY ############################

  def create_company(attrs) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end
end
