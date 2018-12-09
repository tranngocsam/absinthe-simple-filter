defmodule Demo.Employments.Skill do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Demo.Employments.Skill

  @primary_key {:id, :binary_id, autogenerate: true}
  
  schema "skills" do
    has_many :job_skills, Demo.Employments.JobSkill
    has_many :jobs, through: [:job_skills, :job]
    has_many :user_profile_skills, Demo.Employments.UserProfileSkill
    has_many :user_profiles, through: [:user_profile_skills, :user_profile]

    field :name, :string
    field :slug, NameSlug.Type
    field :skill_type, :string
    field :description, :string
    field :image, :string

    timestamps()
  end

  @required_fields ~w(name)a
  @optional_fields ~w(slug skill_type description image)a

  def changeset(%Skill{} = skill, attrs) do
    skill
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
  end

  def filter_fields do
    [
      %{field: :id, type: :binary_id},
      %{field: :name, type: :string}
    ]
  end
end
