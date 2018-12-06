defmodule Demo.Repo.Migrations.CreateUserProfilesSkills do
  use Ecto.Migration

  def change do
    create table(:user_profile_skills, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_profile_id, references(:user_profiles, type: :uuid)
      add :skill_id, references(:skills, type: :uuid)
      add :other_infos, :map

      timestamps()
    end

    create unique_index :user_profile_skills, [:user_profile_id, :skill_id]
  end
end
