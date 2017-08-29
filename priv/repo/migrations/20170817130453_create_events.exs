defmodule Events.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :description, :string
      add :date, :naive_datetime
      add :duration, :integer

      timestamps()
    end

  end
end
