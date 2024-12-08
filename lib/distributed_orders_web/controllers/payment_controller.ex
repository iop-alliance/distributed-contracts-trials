defmodule DistributedOrdersWeb.PaymentController do
  use DistributedOrdersWeb, :controller
  alias DistributedOrders.ApiClient.Flutterwave

  def payment(conn, params) do
    params = Map.drop(params, ["manufacturer_id", "payment_no"])
    response = Flutterwave.transfer_money(params)
    json(conn, %{redirect_link: response.body["data"]["link"]})
  end
end
