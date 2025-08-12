defmodule Aida.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :kind, :string
      add :title, :string
      add :content, :text
      add :tags, {:array, :string}, default: []
      add :first_seen, :date
      add :last_review, :date
      add :next_review, :date
      add :reps, :integer, default: 0, null: false
      add :lapses, :integer, default: 0, null: false
      add :interval_days, :integer, default: 0, null: false
      add :ease, :float, default: 2.5, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
