defmodule Aida.Subscriptions do
  @moduledoc "Create and manage subscription items + reminders."
  alias Aida.Repo
  alias Aida.KB.Item
  alias Aida.Subscriptions.Detail
  import Ecto.Changeset

  # Create item + detail in one transaction
  def create_subscription(attrs) do
    detail = Map.fetch!(attrs, :detail)

    item_changes =
      %Item{}
      |> Item.changeset(%{
        kind: "subscription",
        title: Map.fetch!(attrs, :title),
        content: Map.get(attrs, :content),
        tags: Map.get(attrs, :tags, []),
        first_seen: Map.get(attrs, :first_seen),
        next_review: initial_reminder(detail)
      })

    Repo.transaction(fn ->
      {:ok, item} = Repo.insert(item_changes)

      det_changes =
        %Detail{}
        |> Detail.changeset(Map.put(detail, :item_id, item.id))

      {:ok, _det} = Repo.insert(det_changes)

      Repo.preload(item, :subscription_detail)
    end)
  end

  # Set reminder N days before the charge
  defp initial_reminder(%{next_charge_on: date, lead_days: lead}) when is_integer(lead),
    do: Date.add(date, -lead)

  defp initial_reminder(%{next_charge_on: date}), do: date
  defp initial_reminder(_), do: nil

  # Move to the next billing date and update the reminder
  def roll_forward(%Detail{} = det) do
    new_charge = add_cadence(det.next_charge_on, det.cadence)

    Repo.transaction(fn ->
      {:ok, det2} = det |> change(next_charge_on: new_charge) |> Repo.update()
      item = Repo.preload(det2, :item).item
      next_review = Date.add(det2.next_charge_on, -(det2.lead_days || 0))
      {:ok, _} = item |> change(next_review: next_review) |> Repo.update()
      det2
    end)
  end

  # Simple cadence math
  def add_cadence(date, "weekly"), do: Date.add(date, 7)
  def add_cadence(date, "daily"), do: Date.add(date, 1)

  def add_cadence(%Date{} = date, "monthly") do
    next = Date.add(date, 28)
    day = min(date.day, Date.days_in_month(next))
    Date.new!(next.year, next.month, day)
  end

  def add_cadence(%Date{} = date, "yearly"), do: %Date{date | year: date.year + 1}
  def add_cadence(date, _), do: Date.add(date, 30)
end
