defmodule DistributedOrders.ApiClient.Flutterwave do
  use Tesla
  require Logger

  plug Tesla.Middleware.BaseUrl, get_endpoint()

  plug Tesla.Middleware.Headers, [
    {"Content-Type", "application/json"},
    {"Authorization", "Bearer " <> auth_token()}
  ]

  plug Tesla.Middleware.DecodeJson
  plug Tesla.Middleware.JSON

  def transfer_money(params) do
    post!("/payments", params)
  end

  defp get_endpoint(), do: "https://api.flutterwave.com/v3"

  def auth_token, do: Application.get_env(:distributed_orders, :flutterwave)

end
