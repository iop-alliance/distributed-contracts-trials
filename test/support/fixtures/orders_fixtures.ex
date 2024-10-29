defmodule DistributedOrders.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DistributedOrders.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        documents_url: "some documents_url",
        item_name: "some item_name",
        total_qty: 42
      })
      |> DistributedOrders.Orders.create_order()

    order
  end
end
