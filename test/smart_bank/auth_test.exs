defmodule SmartBank.AuthTest do
  use SmartBank.DataCase

  alias SmartBank.Authentication
  alias SmartBank.Authentication.User

  import SmartBank.Factory

  @valid_user_attrs %{"email" => Faker.Internet.email(), "password" => Faker.String.base64()}

  describe "users" do
    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Authentication.create_user(@valid_user_attrs)
      assert user.email == @valid_user_attrs["email"]
    end

    test "get user by id" do
      user = insert(:user)
      assert {:ok, %User{} = loaded_user} = Authentication.get_user(user.id)
      assert loaded_user.id == user.id
    end

    test "no get user by id, why? not user id" do
      insert(:user)
      assert {:error, _, _} = Authentication.get_user(Ecto.UUID.generate())
    end

    test "get user by email" do
      user = insert(:user)
      assert {:ok, %User{} = loaded_user} = Authentication.get_user_by_email(user.email)
      assert loaded_user.id == user.id
    end

    test "no get user by email, why? not user email" do
      insert(:user)
      assert {:error, _, _} = Authentication.get_user_by_email(Faker.Internet.email())
    end

    test "check pwd and pass" do
      user_attr = %{"email" => Faker.Internet.email(), "password" => Faker.String.base64()}
      assert {:ok, %User{} = user} = Authentication.create_user(user_attr)
      assert {:ok, _, _} = Authentication.authenticate_user(user.email, user_attr["password"])
    end

    test "check pwd and fail" do
      user_attr = %{"email" => Faker.Internet.email(), "password" => Faker.String.base64()}
      assert {:ok, %User{} = user} = Authentication.create_user(user_attr)
      assert {:error, _, _} = Authentication.authenticate_user(user.email, Ecto.UUID.generate())

      assert {:error, _, _} =
               Authentication.authenticate_user(Faker.Internet.email(), user_attr["password"])
    end
  end
end
