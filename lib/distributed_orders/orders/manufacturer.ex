defmodule DistributedOrders.Orders.Manufacturer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "manufacturers" do
    field :email, :string
    field :name, :string
    field :quantity, :integer

    belongs_to :order, DistributedOrders.Orders.Order

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(manufacturer, attrs) do
    manufacturer
    |> cast(attrs, [:name, :email, :quantity, :order_id])
    |> validate_required([:name, :email, :quantity, :order_id])
    |> foreign_key_constraint(:order_id)
  end

  def form_changeset(manufacturer, attrs) do
    manufacturer
    |> cast(attrs, [:name, :email, :quantity])
    |> validate_required([:name, :email, :quantity])
  end
end
