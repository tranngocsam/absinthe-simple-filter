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

  @required_fields ~w(name)a
  @optional_fields ~w(slug dob address website image)a

  def changeset(%UserProfile{} = profile, attrs) do
    profile
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required([:name])
    |> NameSlug.maybe_generate_slug
    |> NameSlug.unique_constraint
  end

  def filter_fields do
    [
      %{field: :id, type: :binary_id},
      %{field: :name, type: :string},
      %{field: :slug, type: :string},
      %{field: :dob, type: :date},
      %{field: :city, type: :string},
      %{field: :state, type: :string},
      %{field: :country, type: :string}
    ]
  end
end
