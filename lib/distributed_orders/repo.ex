defmodule DistributedOrders.Repo do
  use Ecto.Repo,
    otp_app: :distributed_orders,
    adapter: Ecto.Adapters.Postgres
end
