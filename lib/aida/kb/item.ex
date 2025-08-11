defmodule Aida.KB.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :title, :string
    field :kind, :string
    field :content, :string
    field :tags, {:array, :string}
    field :first_seen, :date
    field :last_review, :date
    field :next_review, :date
    field :reps, :integer
    field :lapses, :integer
    field :interval_days, :integer
    field :ease, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:kind, :title, :content, :tags, :first_seen, :last_review, :next_review, :reps, :lapses, :interval_days, :ease])
    |> validate_required([:kind, :title, :content, :tags, :first_seen, :last_review, :next_review, :reps, :lapses, :interval_days, :ease])
  end
end
