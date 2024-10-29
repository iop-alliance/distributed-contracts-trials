defmodule DistributedOrders.Repo.Migrations.CreateQualityInspectors do
  use Ecto.Migration

  def change do
    create table(:quality_inspectors) do
      add :name, :string
      add :email, :string
      add :order_id, references(:orders, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:quality_inspectors, [:order_id])
  end
end
