defmodule Demo.Employments.JobSkill do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Demo.Employments.JobSkill

  @primary_key {:id, :binary_id, autogenerate: true}
  
  schema "job_skills" do
    belongs_to :job, Demo.Employments.Job, type: :binary_id
    belongs_to :skill, Demo.Employments.Skill, type: :binary_id

    field :other_infos, :map

    timestamps()
  end

  @required_fields ~w(job_id skill_id)a
  @optional_fields ~w(other_infos)a

  def changeset(%JobSkill{} = job_skill, attrs) do
    job_skill
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def filter_fields do
    [
      %{field: :id, type: :binary_id},
      %{field: :job_id, type: :string}, 
      %{field: :skill_id, type: :string}
    ]
  end
end
