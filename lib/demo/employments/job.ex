defmodule Demo.Employments.Job do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Demo.Employments.Job

  use AstSimpleFilter.DefineFilterFunctions, Demo.Employments.Job

  @primary_key {:id, :binary_id, autogenerate: true}
  
  schema "jobs" do
    belongs_to :user, Demo.Accounts.User, type: :binary_id
    belongs_to :company, Demo.Accounts.Company, type: :binary_id
    has_many :job_skills, Demo.Employments.JobSkill
    has_many :skills, through: [:job_skills, :skill]

    field :title, :string
    field :slug, TitleSlug.Type
    field :description, :string
    field :close_date, :date
    field :addresses, :map
    field :contract_type, :string
    field :url, :string
    field :salary, :map

    timestamps()
  end

  @required_fields ~w(title)a
  @optional_fields ~w(slug description address website image)a

  def changeset(%Job{} = user, attrs) do
    user
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
  end

  def filter_fields do
    [
      %{field: :title, type: :binary_id},
      %{field: :description, type: :string},
      %{field: :close_date, type: :date},
      %{field: :city, type: :string},
      %{field: :state, type: :string},
      %{field: :country, type: :string},
      %{field: :min_salary, type: :integer},
      %{field: :max_salary, type: :integer},
      %{field: :contract_type, type: :string}
    ]
  end
end
