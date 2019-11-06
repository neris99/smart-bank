defmodule SmartBank.BankTest do
  use SmartBank.DataCase

  alias SmartBank.Bank
  alias SmartBank.Bank.{Account}

  import ExUnit.CaptureIO
  import SmartBank.Factory

  @valid_user_attrs %{"email" => Faker.Internet.email(), "password" => Faker.String.base64()}
  @valid_account_attrs %{"name" => Faker.Name.name()}
  @invalid_account_attrs %{"name" => nil}

  describe "accounts" do
    test "list_accounts/0 returns all accounts" do
      account = insert(:account)
      [loaded_account] = Bank.list_account()
      assert loaded_account.id == account.id
    end

    test "get account" do
      account = insert(:account)

      assert {:ok, _} = account.id |> Bank.get_account()
    end

    test "not get account. why? not found account id" do
      assert {:error, _, 404} = Ecto.UUID.generate() |> Bank.get_account()
    end

    test "create_account/1 with valid data creates a account" do
      user = insert(:user)
      account_attr = @valid_account_attrs |> Map.merge(%{"user_id" => user.id})
      assert {:ok, %Account{} = account} = Bank.create_account(account_attr)
      assert account.name == @valid_account_attrs["name"]
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bank.create_account(@invalid_account_attrs)
    end

    test "test signup" do
      signup_attr = @valid_account_attrs |> Map.merge(@valid_user_attrs)
      assert {:ok, %Account{} = account} = Bank.signup(signup_attr)
    end

    test "test signup with invalid attrs" do
      assert {:error, %Ecto.Changeset{}} = Bank.signup(@invalid_account_attrs)
    end
  end

  describe "transacitonal" do
    test "create deposit with valid attrs" do
      signup_attr = @valid_account_attrs |> Map.merge(@valid_user_attrs)
      assert {:ok, %Account{} = account} = Bank.signup(signup_attr)
      assert account.wallet.amount |> Money.equals?(Money.new(100_000))

      assert {:ok, account, transaction} = account |> Bank.deposit(100_000)
      assert account.wallet.amount |> Money.equals?(Money.new(200_000))
      assert transaction.amount |> Money.equals?(Money.new(100_000))
    end

    test "create deposit with invalid attrs" do
      signup_attr = @valid_account_attrs |> Map.merge(@valid_user_attrs)
      assert {:ok, %Account{} = account} = Bank.signup(signup_attr)
      assert account.wallet.amount |> Money.equals?(Money.new(100_000))

      assert {:error, _} = account |> Bank.deposit(nil)
    end

    test "create withdraw with valid attrs" do
      signup_attr = @valid_account_attrs |> Map.merge(@valid_user_attrs)
      assert {:ok, %Account{} = account} = Bank.signup(signup_attr)
      assert account.wallet.amount |> Money.equals?(Money.new(100_000))

      assert {:ok, account, _} = account |> Bank.withdraw(50_000)
      assert account.wallet.amount |> Money.equals?(Money.new(50_000))
    end

    test "create withdraw with amount greater than limit" do
      signup_attr = @valid_account_attrs |> Map.merge(@valid_user_attrs)
      assert {:ok, %Account{} = account} = Bank.signup(signup_attr)
      assert account.wallet.amount |> Money.equals?(Money.new(100_000))

      assert {:error, _, 500} = account |> Bank.withdraw(100_001)
    end

    test "create a transfer between 2 accounts with valid params" do
      signup_attr = @valid_account_attrs |> Map.merge(@valid_user_attrs)
      assert {:ok, %Account{} = account_a} = Bank.signup(signup_attr)

      assert {:ok, %Account{} = account_b} =
               %{
                 "email" => Faker.Internet.email(),
                 "name" => Faker.Name.name(),
                 "password" => Faker.String.base64()
               }
               |> Bank.signup()

      assert {:ok, %{transaction_a: transaction_a, transaction_b: transaction_b}} =
               account_a |> Bank.transfer(account_b, 50_000)

      assert transaction_a.account_id == account_a.id
      assert transaction_b.account_id == account_b.id
      assert transaction_a |> Map.has_key?(:transaction_id)
      assert transaction_b |> Map.has_key?(:transaction_id)

      {:ok, account_a} = Bank.get_account(account_a.id)
      {:ok, account_b} = Bank.get_account(account_b.id)

      assert account_a.wallet.amount |> Money.equals?(Money.new(50_000))
      assert account_b.wallet.amount |> Money.equals?(Money.new(150_000))
    end

    test "create a transfer between 2 accounts with invalid params" do
      signup_attr = @valid_account_attrs |> Map.merge(@valid_user_attrs)
      assert {:ok, %Account{} = account_a} = Bank.signup(signup_attr)

      assert {:ok, %Account{} = account_b} =
               %{
                 "email" => Faker.Internet.email(),
                 "name" => Faker.Name.name(),
                 "password" => Faker.String.base64()
               }
               |> Bank.signup()

      assert {:error, _} = account_a |> Bank.transfer(account_b, 200_000)
    end

    test "send email" do
      signup_attr = @valid_account_attrs |> Map.merge(@valid_user_attrs)
      assert {:ok, %Account{} = account} = Bank.signup(signup_attr)
      assert {:ok, account, transaction} = account |> Bank.deposit(100_000)

      email_messages = fn ->
        account |> Bank.send_withdraw_mail(transaction)
      end

      assert capture_io(email_messages) =~ "Money withdraw accomplished!"
    end
  end
end
