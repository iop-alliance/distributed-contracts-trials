defmodule DistributedOrders.Repo.Migrations.CreateManufacturers do
  use Ecto.Migration

  def change do
    create table(:manufacturers) do
      add :name, :string
      add :email, :string
      add :quantity, :integer
      add :order_id, references(:orders, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:manufacturers, [:order_id])
  end
end
