defmodule DistributedOrders.Repo.Migrations.AlterManufacturers do
  use Ecto.Migration

  def change do
    alter table(:manufacturers) do
      add :amount, :integer
      add :currency, :string
    end
  end
end
