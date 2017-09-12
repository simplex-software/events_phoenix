defmodule Events.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Events.Accounts.User


  schema "users" do
    field :email, :string
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> hash_password()
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+$/, message: "Email must contain @domain.smth")
    |> unique_constraint(:email)

  end

  def hash_password(changeset) do
    update_change(changeset, :password, &encrypt/1)
  end

  def is_valid_password?(user, password) do
    user.password == encrypt(password)
  end

  defp encrypt(nil), do: nil
  defp encrypt(password) do
    :crypto.hash(:sha, password) |> Base.encode16
  end
end
