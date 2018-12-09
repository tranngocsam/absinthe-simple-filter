defmodule Demo.Accounts.Company do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Demo.Accounts.Company

  use AstSimpleFilter.DefineFilterFunctions, klcass: Demo.Accounts.Company

  @primary_key {:id, :binary_id, autogenerate: true}
  
  schema "companies" do
    has_many :user_companies, Demo.Accounts.UserCompany
    has_many :users, through: [:user_companies, :user]

    field :name, :string
    field :slug, NameSlug.Type
    field :address, :map
    field :website, :string
    field :image, :string

    timestamps()
  end

  @required_fields ~w(name)a
  @optional_fields ~w(slug address website image)a

  def changeset(%Company{} = company, attrs) do
    company
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
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
