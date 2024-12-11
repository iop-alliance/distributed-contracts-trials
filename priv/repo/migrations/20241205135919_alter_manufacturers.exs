defmodule DistributedOrders.Repo.Migrations.AlterManufacturers do
  use Ecto.Migration

  def change do
    alter table(:manufacturers) do
      add :payment_amount_1, :integer
      add :payment_amount_2, :integer
      add :payment_amount_3, :integer
      add :currency, :string
    end
  end
end
