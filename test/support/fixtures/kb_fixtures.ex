defmodule Aida.KBFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Aida.KB` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        content: "some content",
        ease: 120.5,
        first_seen: ~D[2025-08-10],
        interval_days: 42,
        kind: "some kind",
        lapses: 42,
        last_review: ~D[2025-08-10],
        next_review: ~D[2025-08-10],
        reps: 42,
        tags: ["option1", "option2"],
        title: "some title"
      })
      |> Aida.KB.create_item()

    item
  end
end
