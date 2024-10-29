defmodule DistributedOrders.Orders.QualityInspector do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quality_inspectors" do
    field :email, :string
    field :name, :string

    belongs_to :order, DistributedOrders.Orders.Order

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(quality_inspector, attrs) do
    quality_inspector
    |> cast(attrs, [:name, :email, :order_id])
    |> validate_required([:name, :email, :order_id])
    |> foreign_key_constraint(:order_id)
  end

  def form_changeset(quality_inspector, attrs) do
    quality_inspector
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
