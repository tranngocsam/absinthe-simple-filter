defmodule Demo.Accounts.UserProfile do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Demo.Accounts.UserProfile
  use AstSimpleFilter.DefineFilterFunctions, klass: Demo.Accounts.UserProfile

  @primary_key {:id, :binary_id, autogenerate: true}
  
  schema "user_profiles" do
    belongs_to :user, Demo.Accounts.User, type: :binary_id
    has_many :user_profile_skills, Demo.Employments.UserProfileSkill
    has_many :skills, through: [:user_profile_skills, :skill]
    
    field :name, :string
    field :slug, NameSlug.Type
    field :dob, :date
    field :address, :map
    field :website, :string
    field :image, :string

    timestamps()
  end

  @required_fields ~w(user_id name)a
  @optional_fields ~w(slug dob address website image)a

  def changeset(%UserProfile{} = profile, attrs) do
    profile
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_address_field
    |> validate_one_user_profile_per_user(profile)
    |> NameSlug.maybe_generate_slug
    |> NameSlug.unique_constraint
  end

  def filter_fields do
    [
      %{field: :id, type: :binary_id},
      %{field: :name, type: :string},
      %{field: :slug, type: :string},
      %{field: :dob, type: :date},
      %{field: :address, type: :map},
      %{field: :inserted_at, type: :naive_datetime}
    ]
  end

  ############## PRIVATE FUNCTIONS ################

  defp validate_address_field(changeset) do
    validate_change(changeset, :address, fn _, address ->
      if address do
        if is_map(address) do
          diff = Map.keys(address) -- [:street1, :street2, :city, :county, :state, :country, "street1", "street2", "city", "county", "state", "country"]
          if diff && length(diff) > 0 do
            [{:address, "Unkown keys: #{inspect(diff)}"}]
          else
            obj_value = Map.values(address)
              |> Enum.find(fn(value)->
                !String.valid?(value)
              end)

            if obj_value do
              [{:address, "Invalid value: #{inspect(obj_value)}"}]
            else
              []
            end
          end
        else
          [{:address, "is not a map"}]
        end
      end
    end)
  end

  defp validate_one_user_profile_per_user(changeset, user_profile) do
    validate_change(changeset, :user_id, fn _, user_id ->
      query = from up in "user_profiles", select: map(up, [:id])
      {:ok, user_uuid} = Ecto.UUID.dump(user_id)
      user_profile_ids = query
        |> where(user_id: ^user_uuid)
        |> Demo.Repo.all
        |> Enum.map(fn(up)->
          {:ok, up_id} = Ecto.UUID.cast(up.id)
          up_id
        end)

      user_profile_id = Ecto.Changeset.get_change(changeset, :id, user_profile.id)
      if user_profile_id do
        if Enum.member?(user_profile_ids, user_profile_id) do
          []
        else
          [{:user_id, "already taken"}]
        end
      else
        if length(user_profile_ids) > 0 do
          [{:user_id, "already taken"}]
        else
          []
        end
      end
    end)
  end
end
