defmodule Demo.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :slug, :string
      add :address, :map
      add :website, :string
      add :image, :string

      timestamps()
    end

    create unique_index :companies, [:name]
    create unique_index :companies, [:slug]
  end
end
