defmodule Events.AccountsTest do
  use Events.DataCase

  alias Events.Accounts

  describe "users" do
    alias Events.Accounts.User

    @valid_attrs %{email: "some_email@simplex.software", password: "some password"}
    @update_attrs %{email: "some_updated_email@simplex.software", password: "some updated password"}
    @invalid_attrs %{email: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      expected_user = user_fixture()
      email = Accounts.list_users() |> Enum.map(fn user -> user.email end)
      assert email == [expected_user.email]
    end

    test "get_user!/1 returns the user with given id" do
      expected_user = user_fixture()
      user = Accounts.get_user!(expected_user.id)
      assert expected_user.email == user.email
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some_email@simplex.software"
      assert user.password != nil
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some_updated_email@simplex.software"
      assert user.password != nil
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user.email == Accounts.get_user!(user.id).email
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
