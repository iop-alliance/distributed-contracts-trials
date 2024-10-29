defmodule DistributedOrdersWeb.HomeLive.Index do
  use DistributedOrdersWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
