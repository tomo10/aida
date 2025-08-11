defmodule Aida.KB do
  @moduledoc """
  The KB context.
  """

  import Ecto.Query, warn: false
  alias Aida.Repo
  alias Aida.KB.Review

  alias Aida.KB.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(Item)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  @doc """
  Review an item with a grade (0–3) and optional notes.

  Grades:
    0 = Again (failed recall) → shorten interval drastically
    1 = Hard (barely recalled) → slightly reduce ease, shorter growth
    2 = Good (correct, some effort) → normal growth
    3 = Easy (instant recall) → grow interval, bump ease

  Updates:
    - Item SRS fields: reps, lapses, interval_days, ease, next_review
    - Adds a Review row with before/after snapshot and notes
  """
  def review_item(%Item{} = item, grade, notes \\ nil) when grade in 0..3 do
    before = %{ease: item.ease, interval: item.interval_days}

    updated =
      item
      |> schedule(grade)
      |> Map.put(:last_review, Date.utc_today())

    Repo.transaction(fn ->
      {:ok, saved} =
        item
        |> Changeset.change(%{
          reps: updated.reps,
          lapses: updated.lapses,
          interval_days: updated.interval_days,
          ease: updated.ease,
          next_review: updated.next_review,
          last_review: updated.last_review
        })
        |> Repo.update()

      {:ok, _rev} =
        %Review{}
        |> Review.changeset(%{
          item_id: saved.id,
          reviewed_at: DateTime.utc_now(),
          grade: grade,
          interval_before: before.interval,
          interval_after: saved.interval_days,
          ease_before: before.ease,
          ease_after: saved.ease,
          notes: notes
        })
        |> Repo.insert()

      saved
    end)
  end

  @doc """
  Internal SRS scheduler — modifies ease/interval based on grade.
  """
  def schedule(%Item{ease: e, interval_days: i, reps: r, lapses: l} = item, grade) do
    {e2, i2, l2} =
      case grade do
        # fail: reset interval
        0 -> {max(e - 0.20, 1.30), 1, l + 1}
        # hard: halve interval
        1 -> {max(e - 0.10, 1.30), max(1, div(max(i, 1), 2)), l}
        # good: normal growth
        2 -> {e, if(i <= 0, do: 1, else: round(i * e)), l}
        # easy: bump ease & interval
        3 -> {e + 0.15, if(i <= 0, do: 3, else: round(i * e) + 1), l}
      end

    today = Date.utc_today()

    %Item{
      item
      | reps: r + 1,
        lapses: l2,
        interval_days: i2,
        ease: Float.round(e2, 2),
        next_review: Date.add(today, i2)
    }
  end

  @doc """
  Fetch all items due for review today or earlier.

  Options:
    :kinds — list of kinds to filter by (["vocab", "subscription"])
    :limit — max number of items to return
  """
  def due_items(opts \\ %{}) do
    kinds = Map.get(opts, :kinds, :all)
    limit = Map.get(opts, :limit, 50)

    query =
      from i in Item,
        where: not is_nil(i.next_review) and i.next_review <= ^Date.utc_today(),
        order_by: [asc: i.next_review],
        limit: ^limit

    query =
      case kinds do
        :all -> query
        list when is_list(list) -> from i in query, where: i.kind in ^list
      end

    Repo.all(query)
  end
end
