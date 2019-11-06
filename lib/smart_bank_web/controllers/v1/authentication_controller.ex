defmodule SmartBankWeb.V1.AuthenticationController do
  use SmartBankWeb, :controller

  alias SmartBank.Authentication

  action_fallback SmartBankWeb.FallbackController

  def signin(conn, params) do
    with {:ok, _, token} <- params["email"] |> Authentication.authenticate_user(params["password"]) do
      conn
      |> render("Authentication.json", token: token)
    end
  end
end
