defmodule Events.Social.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Events.Social.Event

  schema "events" do
    field :date, :naive_datetime
    field :description, :string
    field :duration, :integer
    field :title, :string
    has_many :comments, Events.Social.Comment

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:title, :description, :date, :duration])
    |> validate_required([:title, :description, :date, :duration])
  end
end
