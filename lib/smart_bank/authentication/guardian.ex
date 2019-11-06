defmodule SmartBank.Authentication.Guardian do
  @moduledoc false

  use Guardian, otp_app: :SmartBank

  alias SmartBank.Authentication

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    Authentication.get_user(id)
  end
end
