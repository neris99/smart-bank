defmodule SmartBankWeb.V1.AuthenticationView do
  use SmartBankWeb, :view

  def render("Authentication.json", %{token: token}) do
    %{token: token}
  end
end
