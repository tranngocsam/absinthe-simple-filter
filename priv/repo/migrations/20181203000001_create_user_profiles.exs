defmodule Demo.Repo.Migrations.CreateUserProfiles do
  use Ecto.Migration

  def change do
    create table(:user_profiles, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid)
      add :user_type, :string
      add :name, :string
      add :slug, :string
      add :dob, :date
      add :address, :map
      add :website, :string
      add :image, :string

      timestamps()
    end

    create unique_index :user_profiles, [:slug]
  end
end
