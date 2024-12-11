defmodule DistributedOrdersWeb.PaymentController do
  use DistributedOrdersWeb, :controller
  alias DistributedOrders.ApiClient.Flutterwave
  alias DistributedOrders.Orders

  def payment(conn, params) do
    manufacturer = Orders.get_manufacturer(params["manufacturer_id"])
    amount = get_payment_amount(params["payment_no"], manufacturer)

    params = %{
      "tx_ref" => "ref_#{manufacturer.id}",
      "currency" => manufacturer.currency,
      "amount" => Integer.to_string(amount),
      "customer" => %{
        "email" => manufacturer.email,
        "name" => manufacturer.name
      },
      "redirect_url" => params["redirect_url"]
    }
    response = Flutterwave.transfer_money(params)
    json(conn, %{redirect_link: response.body["data"]["link"]})
  end

  defp get_payment_amount(1, manufacturer), do: manufacturer.payment_amount_1
  defp get_payment_amount(2, manufacturer), do: manufacturer.payment_amount_2
  defp get_payment_amount(_, manufacturer), do: manufacturer.payment_amount_3
end
