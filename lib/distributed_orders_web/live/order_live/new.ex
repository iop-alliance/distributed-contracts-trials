defmodule DistributedOrdersWeb.OrderLive.New do
  use DistributedOrdersWeb, :live_view

  alias DistributedOrders.Orders
  alias DistributedOrders.Orders.{Order, Initiator, QualityInspector, Manufacturer}

  @impl true
  def mount(_params, _session, socket) do
    order = %Order{}
    initiator = %Initiator{}
    quality_inspector = %QualityInspector{}
    manufacturer = %Manufacturer{}
    manufacturers = []

    {:ok,
     socket
     |> assign(page_title: "New Order")
     |> assign(order_details_submitted: false)
     |> assign(initiator_submitted: false)
     |> assign(quality_inspector_submitted: false)
     |> assign(add_manufacturer: false)
     |> assign(quantity_assigned: 0)
     |> assign(order: order)
     |> assign(initiator: initiator)
     |> assign(quality_inspector: quality_inspector)
     |> assign(manufacturer: manufacturer)
     |> assign(step: "order")
     |> assign(manufacturers: manufacturers)
     |> assign_new(:order_form, fn ->
       to_form(Orders.change_order(order))
     end)
     |> assign_new(:initiator_form, fn ->
       to_form(Orders.change_initiator(initiator))
     end)
     |> assign_new(:quality_inspector_form, fn ->
       to_form(Orders.change_quality_inspector_form(quality_inspector))
     end)
     |> assign_new(:manufacturer_form, fn ->
       to_form(Orders.change_manufacturer_form(manufacturer))
     end)
     |> assign_new(:full_order_form, fn ->
       to_form(%{})
     end)}
  end

  @impl true
  def handle_event("validate_order", %{"order" => order_params}, socket) do
    changeset = Orders.change_order(socket.assigns.order, order_params)
    {:noreply, assign(socket, order_form: to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("save_order", %{"order" => order_params}, socket) do
    changeset =
      %Order{}
      |> Orders.change_order(order_params)
      |> Map.put(:action, :insert)

    if changeset.valid? do
      {:noreply,
      socket
      |> assign(order_changeset: changeset)
      |> assign(order_details_submitted: true)
      |> assign(step: "initiator")}
    else
      {:noreply, assign(socket, order_changeset: changeset)}
    end
  end

  def handle_event("validate_initiator", %{"initiator" => initiator_params}, socket) do
    changeset = Orders.change_initiator(socket.assigns.initiator, initiator_params)
    {:noreply, assign(socket, order_form: to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("save_initiator", %{"initiator" => initiator_params}, socket) do
    changeset =
      %Initiator{}
      |> Orders.change_initiator(initiator_params)
      |> Map.put(:action, :insert)

    if changeset.valid? do
      {:noreply,
        socket
        |> assign(initiator_changeset: changeset)
        |> assign(initiator_submitted: true)
        |> assign(step: "quality_inspector")}
      else
        {:noreply, assign(socket, initiator_changeset: changeset)}
      end
    end

    def handle_event("validate_quality_inspector", %{"quality_inspector" => quality_inspector_params}, socket) do
      changeset = Orders.change_quality_inspector_form(socket.assigns.quality_inspector, quality_inspector_params)
      {:noreply, assign(socket, quality_inspector_form: to_form(changeset, action: :validate))}
    end

    def handle_event("save_quality_inspector", %{"quality_inspector" => quality_inspector_params}, socket) do
      changeset =
        %QualityInspector{}
        |> Orders.change_quality_inspector_form(quality_inspector_params)
        |> Map.put(:action, :insert)

        if changeset.valid? do
          {:noreply,
          socket
          |> assign(quality_inspector_changeset: changeset)
          |> assign(quality_inspector_submitted: true)
          |> assign(add_manufacturer: true)
          |> assign(step: "manufacturer")}
    else
      {:noreply, assign(socket, quality_inspector_changeset: changeset)}
    end
  end

  def handle_event("validate_manufacturer", %{"manufacturer" => manufacturer_params}, socket) do
    changeset = Orders.change_manufacturer_form(socket.assigns.manufacturer, manufacturer_params)
    {:noreply, assign(socket, manufacturer_form: to_form(changeset, action: :validate))}
  end

  def handle_event("save_manufacturer", %{"manufacturer" => manufacturer_params}, socket) do
    changeset =
      %Manufacturer{}
      |> Orders.change_manufacturer_form(manufacturer_params)
      |> Map.put(:action, :insert)

    if changeset.valid? do
      manufacturers = socket.assigns.manufacturers ++ [changeset]
      {:noreply,
          socket
          |> assign(manufacturer_changeset: changeset)
          |> assign(manufacturers: manufacturers)
          |> assign(add_manufacturer: false)
          |> assign(quantity_assigned: socket.assigns.quantity_assigned + String.to_integer(manufacturer_params["quantity"]))}
    else
      {:noreply, assign(socket, manufacturer_changeset: changeset)}
    end
  end

  def handle_event("add_new_manufacturer", _params, socket) do
    {:noreply,
    socket
    |> assign(add_manufacturer: true)
    |> assign(:manufacturer_form, to_form(Orders.change_manufacturer_form(%Manufacturer{})))}
  end

  def handle_event("submit_full_order", _params, socket) do
    # Transaction to save all data
    case Orders.create_full_order(
           socket.assigns.order_changeset,
           socket.assigns.initiator_changeset,
           socket.assigns.quality_inspector_changeset,
           socket.assigns.manufacturers
         ) do
      {:ok, order} ->
        results = Orders.start_order_process(order)
        IO.inspect(results)
        {:noreply,
         socket
         |> put_flash(:info, "Order created successfully.")
         |> redirect(to: ~p"/orders/#{order.id}")}
      {:error, changeset} ->
        {:noreply, assign(socket, order_changeset: changeset)}
    end
  end
end
