defmodule SmartBank.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :account_id, references(:accounts, type: :uuid)
      add :amount, :integer

      timestamps()
    end

    create index(:wallets, [:account_id])
  end
end
