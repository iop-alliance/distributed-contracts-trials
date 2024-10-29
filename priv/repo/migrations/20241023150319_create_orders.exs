defmodule DistributedOrders.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :item_name, :string
      add :documents_url, :string
      add :total_qty, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
