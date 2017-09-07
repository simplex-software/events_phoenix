defmodule Events.Social.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Events.Social.Comment

  schema "comments" do
    field :body, :string
    field :event_id, :id
    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
