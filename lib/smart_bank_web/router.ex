defmodule SmartBankWeb.Router do
  use SmartBankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug SmartBank.Authentication.Pipeline
  end

  # Unauthenticated routes

  scope "/api", SmartBankWeb do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      post "/signin", AuthenticationController, :signin
      post "/signup", AccountController, :create
    end

    scope "/v1", V1, as: :v1 do
      pipe_through [:authenticated]

      get "/accounts", AccountController, :index

      post "/deposit", TransactionController, :deposit
      post "/transfer", TransactionController, :transfer
      post "/withdraw", TransactionController, :withdraw

      get "/wallet/:account_id", TransactionController, :wallet
      get "/report", TransactionController, :report
    end
  end
end
