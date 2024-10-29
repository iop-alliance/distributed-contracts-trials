defmodule DistributedOrders.Repo.Migrations.CreateInitiators do
  use Ecto.Migration

  def change do
    create table(:initiators) do
      add :name, :string
      add :email, :string
      add :order_id, references(:orders, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:initiators, [:order_id])
  end
end
