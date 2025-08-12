defmodule AidaWeb.LanguageLive.Index do
  use AidaWeb, :live_view
  alias Aida.KB

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(Aida.PubSub, "kb_updates")
    {:ok, load_due(socket)}
  end

  defp load_due(socket) do
    due = KB.due_items(%{})
    # change this query so its language shit only
    KB.list_items()

    assign(socket, due: due, current: List.first(due), idx: 0)
  end

  @impl true
  def handle_event("grade", %{"grade" => _g}, %{assigns: %{current: nil}} = socket) do
    {:noreply, socket}
  end

  def handle_event("grade", %{"grade" => g}, socket) do
    grade = String.to_integer(g)
    {:ok, _item} = KB.review_item(socket.assigns.current, grade)

    next_idx = socket.assigns.idx + 1
    next_item = Enum.at(socket.assigns.due, next_idx)

    {:noreply, assign(socket, current: next_item, idx: next_idx)}
  end

  @impl true
  def handle_info(_msg, socket), do: {:noreply, load_due(socket)}
end
