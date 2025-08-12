defmodule Aida.Subscriptions.Detail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscription_details" do
    belongs_to :item, Aida.KB.Item

    field :meta, :map
    field :currency, :string
    field :vendor, :string
    field :amount_cents, :integer
    field :cadence, :string
    field :next_charge_on, :date
    field :lead_days, :integer
    field :payment_method, :string, default: "credit_card"
    field :cancel_at, :date

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(detail, attrs) do
    detail
    |> cast(attrs, [
      :item_id,
      :vendor,
      :amount_cents,
      :currency,
      :cadence,
      :next_charge_on,
      :lead_days,
      :payment_method,
      :cancel_at,
      :meta
    ])
    |> validate_required([
      :item_id,
      :vendor,
      :amount_cents,
      :currency,
      :cadence,
      :next_charge_on,
      :lead_days,
      :payment_method
    ])
  end
end
