defmodule DistributedOrders.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias DistributedOrders.Repo

  alias DistributedOrders.Orders.{Order, Initiator, QualityInspector, Manufacturer}

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  def change_order_form(%Order{} = order, attrs \\ %{}) do
    Order.form_changeset(order, attrs)
  end

  def change_initiator(%Initiator{} = initiator, attrs \\ %{}) do
    Initiator.changeset(initiator, attrs)
  end

  def change_quality_inspector(%QualityInspector{} = quality_inspector, attrs \\ %{}) do
    QualityInspector.changeset(quality_inspector, attrs)
  end

  def change_quality_inspector_form(%QualityInspector{} = quality_inspector, attrs \\ %{}) do
    QualityInspector.form_changeset(quality_inspector, attrs)
  end

  def change_manufacturer(%Manufacturer{} = manufacturer, attrs \\ %{}) do
    Manufacturer.changeset(manufacturer, attrs)
  end

  def change_manufacturer_form(%Manufacturer{} = manufacturer, attrs \\ %{}) do
    Manufacturer.form_changeset(manufacturer, attrs)
  end

  def create_full_order(order_changeset, initiator_changeset, quality_inspector_changeset, manufacturer_changesets) do

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:order, order_changeset)
    |> Ecto.Multi.insert(:initiator, fn %{order: order} ->
      Ecto.Changeset.put_assoc(initiator_changeset, :order, order)
    end)
    |> Ecto.Multi.insert(:quality_inspector, fn %{order: order} ->
      Ecto.Changeset.put_assoc(quality_inspector_changeset, :order, order)
    end)
    |> Ecto.Multi.insert_all(:manufacturers, Manufacturer, fn %{order: order} ->
      insert_manufacturers(manufacturer_changesets, order.id)
  end)
    |> Repo.transaction()
    |> case do
      {:ok, %{order: order}} -> {:ok, order}
      {:error, _, changeset, _} ->
        {:error, changeset}
    end
  end

  defp insert_manufacturers(changesets, order_id) do
    current_time = DateTime.truncate(DateTime.utc_now(), :second)
    manufacturer_changesets =
      Enum.map(changesets, fn changeset ->
        Map.put(changeset.changes, :order_id, order_id)
        |> Map.put(:inserted_at, current_time)
        |> Map.put(:updated_at, current_time)
      end)
    manufacturer_changesets
  end

  def start_order_process(order) do
    order_details = Repo.get!(Order, order.id) |> Repo.preload([:initiator, :quality_inspector, :manufacturers])
    req_url = "https://cloud.activepieces.com/api/v1/webhooks/KVYuTaKpSYODBlXNTnZGX"
    results = for manufacturer <- order_details.manufacturers do
      req_body = %{
        product_name: order_details.item_name,
        product_url: order_details.item_details,
        initiator_name: order_details.initiator.name,
        initiator_email: order_details.initiator.email,
        qi_name: order_details.quality_inspector.name,
        qi_email: order_details.quality_inspector.email,
        manufacturer_id: manufacturer.id,
        manufacturer_name: manufacturer.name,
        manufacturer_email: manufacturer.email,
        amount: manufacturer.amount,
        currency: manufacturer.currency,
        quantity: manufacturer.quantity
      }

      case Req.post!(req_url, json: req_body) do
        %{status: 200} -> {manufacturer.name, :ok}
        %{status: 400} -> {manufacturer.name, :error}
      end
    end
    results
  end
end
