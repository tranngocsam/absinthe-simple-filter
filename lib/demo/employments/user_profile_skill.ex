defmodule Demo.Employments.UserProfileSkill do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Demo.Employments.UserProfileSkill

  @primary_key {:id, :binary_id, autogenerate: true}
  
  schema "user_profile_skills" do
    belongs_to :user_profile, Demo.Accounts.UserProfile, type: :binary_id
    belongs_to :skill, Demo.Employments.Skill, type: :binary_id

    field :other_infos, :map

    timestamps()
  end

  @required_fields ~w(user_profile_id skill_id)a
  @optional_fields ~w(other_infos)a

  def changeset(%UserProfileSkill{} = user_profile_skill, attrs) do
    user_profile_skill
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
  end

  def filter_fields do
    [
      %{field: :id, type: :binary_id},
      %{field: :user_profile_id, type: :string}, 
      %{field: :skill_id, type: :string}
    ]
  end
end
