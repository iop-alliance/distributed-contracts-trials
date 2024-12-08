defmodule DistributedOrders.Repo.Migrations.AlterManufacturers do
  use Ecto.Migration

  def change do
    alter table(:manufacturers) do
      add :amount, :integer
      add :currency, :string

      timestamps(type: :utc_datetime)
    end
  end
end
