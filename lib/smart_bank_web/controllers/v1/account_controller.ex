defmodule SmartBankWeb.V1.AccountController do
  use SmartBankWeb, :controller

  alias SmartBank.Bank
  alias SmartBank.Bank.Account

  action_fallback SmartBankWeb.FallbackController

  def index(conn, _params) do
    accounts = Bank.list_account()
    render(conn, "index.json", accounts: accounts)
  end

  def create(conn, account_params) do
    with {:ok, %Account{} = account} <- account_params |> Bank.signup() do
      conn
      |> put_status(:created)
      |> render("show.json", account: account)
    end
  end
end
