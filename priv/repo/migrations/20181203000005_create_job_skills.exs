defmodule Demo.Repo.Migrations.CreateJobsSkills do
  use Ecto.Migration

  def change do
    create table(:job_skills, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :job_id, references(:jobs, type: :uuid)
      add :skill_id, references(:skills, type: :uuid)
      add :other_infos, :map

      timestamps()
    end

    create unique_index :job_skills, [:job_id, :skill_id]
  end
end
