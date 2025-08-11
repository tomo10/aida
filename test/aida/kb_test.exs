defmodule Aida.KBTest do
  use Aida.DataCase

  alias Aida.KB

  describe "items" do
    alias Aida.KB.Item

    import Aida.KBFixtures

    @invalid_attrs %{title: nil, kind: nil, content: nil, tags: nil, first_seen: nil, last_review: nil, next_review: nil, reps: nil, lapses: nil, interval_days: nil, ease: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert KB.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert KB.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{title: "some title", kind: "some kind", content: "some content", tags: ["option1", "option2"], first_seen: ~D[2025-08-10], last_review: ~D[2025-08-10], next_review: ~D[2025-08-10], reps: 42, lapses: 42, interval_days: 42, ease: 120.5}

      assert {:ok, %Item{} = item} = KB.create_item(valid_attrs)
      assert item.title == "some title"
      assert item.kind == "some kind"
      assert item.content == "some content"
      assert item.tags == ["option1", "option2"]
      assert item.first_seen == ~D[2025-08-10]
      assert item.last_review == ~D[2025-08-10]
      assert item.next_review == ~D[2025-08-10]
      assert item.reps == 42
      assert item.lapses == 42
      assert item.interval_days == 42
      assert item.ease == 120.5
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = KB.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{title: "some updated title", kind: "some updated kind", content: "some updated content", tags: ["option1"], first_seen: ~D[2025-08-11], last_review: ~D[2025-08-11], next_review: ~D[2025-08-11], reps: 43, lapses: 43, interval_days: 43, ease: 456.7}

      assert {:ok, %Item{} = item} = KB.update_item(item, update_attrs)
      assert item.title == "some updated title"
      assert item.kind == "some updated kind"
      assert item.content == "some updated content"
      assert item.tags == ["option1"]
      assert item.first_seen == ~D[2025-08-11]
      assert item.last_review == ~D[2025-08-11]
      assert item.next_review == ~D[2025-08-11]
      assert item.reps == 43
      assert item.lapses == 43
      assert item.interval_days == 43
      assert item.ease == 456.7
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = KB.update_item(item, @invalid_attrs)
      assert item == KB.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = KB.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> KB.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = KB.change_item(item)
    end
  end
end
