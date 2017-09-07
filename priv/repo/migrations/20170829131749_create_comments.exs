defmodule Events.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:event_id])
  end
end
