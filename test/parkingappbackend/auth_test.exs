defmodule Parkingappbackend.AuthTest do
  use Parkingappbackend.DataCase

  alias Parkingappbackend.Auth

  describe "users" do
    alias Parkingappbackend.Auth.User

    @valid_attrs %{age: 42, address: "some address", email: "some email", is_active: true, username: "some username", password: "some password"}
    @update_attrs %{age: 43, address: "some updated address", email: "some updated email", is_active: false, username: "some updated username", password: "some password"}
    @invalid_attrs %{age: nil, address: nil, email: nil, is_active: nil, username: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

     #user
     %{user | password: nil}
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
      assert Pbkdf2.verify_pass("some password", user.password_hash)
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.age == 42
      assert user.address == "some address"
      assert user.email == "some email"
      assert user.is_active == true
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Auth.update_user(user, @update_attrs)
      assert user.age == 43
      assert user.address == "some updated address"
      assert user.email == "some updated email"
      assert user.is_active == false
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
      assert Pbkdf2.verify_pass("some password", user.password_hash)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end
end
