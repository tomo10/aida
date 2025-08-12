defmodule Aida.KB.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    has_one :subscription_detail, Aida.Subscriptions.Detail

    field :title, :string
    field :kind, :string
    field :content, :string
    field :tags, {:array, :string}
    field :first_seen, :date
    field :last_review, :date
    field :next_review, :date
    field :reps, :integer, default: 0
    field :lapses, :integer, default: 0
    field :interval_days, :integer, default: 0
    field :ease, :float, default: 2.5

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [
      :kind,
      :title,
      :content,
      :tags,
      :first_seen,
      :last_review,
      :next_review,
      :reps,
      :lapses,
      :interval_days,
      :ease
    ])
    |> validate_required([
      :kind,
      :title
    ])
  end
end
