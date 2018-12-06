defmodule Demo.Repo.Migrations.CreateUserCompanies do
  use Ecto.Migration

  def change do
    create table(:user_companies, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid)
      add :company_id, references(:companies, type: :uuid)
      add :position, :string

      timestamps()
    end

    create unique_index :user_companies, [:user_id, :company_id]
  end
end
