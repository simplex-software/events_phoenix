defmodule Events.Social.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Events.Social.User
  alias Events.Social.Event

  schema "users" do
    field :name, :string
    field :email, :string
    many_to_many :events, Event, join_through: "events_users"

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
