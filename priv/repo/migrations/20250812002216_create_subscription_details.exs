defmodule Aida.Repo.Migrations.CreateSubscriptionDetails do
  use Ecto.Migration

  def change do
    create table(:subscription_details) do
      add :item_id, references(:items, on_delete: :delete_all), null: false

      add :vendor, :string
      add :amount_cents, :integer
      add :currency, :string
      add :cadence, :string
      # "monthly" | "yearly" | "weekly" | "daily"
      add :next_charge_on, :date
      add :lead_days, :integer
      add :payment_method, :string, default: "credit_card"
      add :cancel_at, :date
      add :meta, :map

      timestamps(type: :utc_datetime)
    end

    create index(:subscription_details, [:item_id])
    create index(:subscription_details, [:vendor])
    create index(:subscription_details, [:next_charge_on])
  end
end
