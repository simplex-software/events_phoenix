defmodule Events.Repo.Migrations.AddSchema do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string

      timestamps
    end

   create table(:events) do
     add :title, :string
     add :description, :string
     add :date, :naive_datetime
     add :duration, :integer
     add :owner_id, references(:users)
     add :participants, references(:users)
     timestamps
   end

   create table(:events_users, private_key: false) do
      add :event_id, references(:events)
      add :user_id, references(:users)

   end

  end
end
