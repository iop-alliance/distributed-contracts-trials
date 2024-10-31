defmodule DistributedOrders.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias DistributedOrders.Orders.{Initiator, QualityInspector, Manufacturer}

  schema "orders" do
    field :item_details, :string
    field :item_name, :string
    field :total_qty, :integer

    has_one :initiator, Initiator
    has_one :quality_inspector, QualityInspector
    has_many :manufacturers, Manufacturer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:item_name, :item_details, :total_qty])
    |> validate_required([:item_name, :total_qty])
  end

  @doc false
  def form_changeset(order, attrs) do
    order
    |> cast(attrs, [:item_name, :item_details, :total_qty])
    |> validate_required([:item_name, :total_qty])
  end
end
