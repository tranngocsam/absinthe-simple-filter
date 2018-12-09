defmodule Demo.Accounts.UserCompany do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Demo.Accounts.UserCompany

  @primary_key {:id, :binary_id, autogenerate: true}
  
  schema "user_profiles" do
    belongs_to :user, Demo.Accounts.User, type: :binary_id
    belongs_to :company, Demo.Accounts.Company, type: :binary_id

    field :position, :string

    timestamps()
  end

  @required_fields ~w(user_id company_id)a
  @optional_fields ~w(position)a

  def changeset(%UserCompany{} = user_company, attrs) do
    user_company
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def filter_fields do
    [
      %{field: :id, type: :binary_id},
      %{field: :user_id, type: :string}, 
      %{field: :company_id, type: :string}, 
      %{field: :position, type: :string}
    ]
  end
end
