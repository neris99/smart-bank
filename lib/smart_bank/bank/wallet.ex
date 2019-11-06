defmodule SmartBank.Bank.Wallet do
  @moduledoc """
  Wallet entity, store last state of user wallet
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "wallets" do
    belongs_to :account, SmartBank.Bank.Account, type: :binary_id

    field :amount, Money.Ecto.Amount.Type

    timestamps()
  end

  @required_fields ~w(account_id amount)a

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
