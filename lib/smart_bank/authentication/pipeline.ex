defmodule SmartBank.Authentication.Pipeline do
  @moduledoc """
  Pipeline that ensures the user is authenticated
  """

  use Guardian.Plug.Pipeline,
    otp_app: :SmartBank,
    error_handler: SmartBank.Authentication.ErrorHandler,
    module: SmartBank.Authentication.Guardian

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
  plug SmartBank.Authentication.CurrentUser
end
