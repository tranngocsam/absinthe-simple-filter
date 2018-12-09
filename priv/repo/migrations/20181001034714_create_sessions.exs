defmodule Demo.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add(:user_id, references(:users, type: :uuid, on_delete: :delete_all))
      add(:expires_at, :utc_datetime)

      timestamps()
    end
  end
end
