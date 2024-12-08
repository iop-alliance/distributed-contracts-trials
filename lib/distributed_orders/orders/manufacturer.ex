defmodule DistributedOrders.Orders.Manufacturer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "manufacturers" do
    field :email, :string
    field :name, :string
    field :quantity, :integer
    field :amount, :integer
    field :currency, :string

    belongs_to :order, DistributedOrders.Orders.Order

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(manufacturer, attrs \\ %{}) do
    manufacturer
    |> cast(attrs, [:name, :email, :quantity, :amount, :currency, :order_id])
    |> validate_required([:name, :email, :quantity, :amount, :currency, :order_id])
    |> foreign_key_constraint(:order_id)
  end

  def form_changeset(manufacturer, attrs \\ %{}) do
    manufacturer
    |> cast(attrs, [:name, :email, :quantity, :amount, :currency])
    |> validate_required([:name, :email, :quantity, :amount, :currency])
  end
end
