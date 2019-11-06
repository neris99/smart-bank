defmodule SmartBank.Repo do
  use Ecto.Repo,
    otp_app: :SmartBank,
    adapter: Ecto.Adapters.Postgres
end
