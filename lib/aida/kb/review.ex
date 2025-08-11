defmodule Aida.KB.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :reviewed_at, :utc_datetime
    field :grade, :integer
    field :notes, :string

    # SRS state snapshot before and after review
    field :interval_before, :integer
    field :interval_after, :integer
    field :ease_before, :float
    field :ease_after, :float

    belongs_to :item, Aida.KB.Item

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [
      :item_id,
      :reviewed_at,
      :grade,
      :notes,
      :interval_before,
      :interval_after,
      :ease_before,
      :ease_after
    ])
    |> validate_required([
      :item_id,
      :reviewed_at,
      :grade
    ])
    |> validate_inclusion(:grade, 0..3)
  end
end
