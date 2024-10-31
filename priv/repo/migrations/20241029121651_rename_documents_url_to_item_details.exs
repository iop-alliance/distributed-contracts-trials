defmodule DistributedOrders.Repo.Migrations.RenameDocumentsUrlToItemDetails do
  use Ecto.Migration

  def change do
    rename table(:orders), :documents_url, to: :item_details
    alter table(:orders) do
      modify :item_details, :text
    end
  end

  def down do
    rename table(:orders), :item_details, to: :documents_url
    alter table(:orders) do
      modify :documents_url, :string
    end
  end
end
