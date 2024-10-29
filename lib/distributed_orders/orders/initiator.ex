defmodule DistributedOrders.Orders.Initiator do
  use Ecto.Schema
  import Ecto.Changeset

  schema "initiators" do
    field :email, :string
    field :name, :string

    belongs_to :order, DistributedOrders.Orders.Order

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(initiator, attrs) do
    initiator
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
