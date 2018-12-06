defmodule Demo.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  def change do
    create table(:skills, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :slug, :string
      add :skill_type, :string
      add :description, :string
      add :image, :string

      timestamps()
    end

    create unique_index :skills, [:name, :skill_type]
    create unique_index :skills, [:slug]
  end
end
