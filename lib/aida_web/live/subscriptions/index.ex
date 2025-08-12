defmodule AidaWeb.SubscriptionsLive.Index do
  use AidaWeb, :live_view
  alias Aida.Subscriptions
  alias Aida.Repo
  alias Aida.Subscriptions.Detail

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(Aida.PubSub, "kb_updates")
    {:ok, load(socket)}
  end

  defp load(socket) do
    # naive query: all subscription detail + preloaded item
    details = Repo.all(Detail) |> Repo.preload(:item)
    assign(socket, details: details)
  end
end
