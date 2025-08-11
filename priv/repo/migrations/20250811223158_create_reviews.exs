defmodule Aida.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :reviewed_at, :utc_datetime
      add :grade, :integer
      add :notes, :text
      add :interval_before, :integer
      add :interval_after, :integer
      add :ease_before, :float
      add :ease_after, :float
      add :item_id, references(:items, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:reviews, [:item_id])
  end
end
