defmodule Demo.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid)
      add :company_id, references(:companies, type: :uuid)
      add :title, :string
      add :slug, :string
      add :description, :text
      add :close_date, :date
      add :addresses, :map
      add :contract_type, :string
      add :url, :string
      add :salary, :map

      timestamps()
    end

    create unique_index :jobs, [:slug]
  end
end
