defmodule InventoryManagementWeb.ProductLive.Index do
  use InventoryManagementWeb, :live_view

  alias InventoryManagement.Products
  alias InventoryManagement.Products.Product
  alias InventoryManagement.Products.Reorder

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :products, list_products())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Products.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Products.get_product!(id)
    {:ok, _} = Products.delete_product(product)

    {:noreply, assign(socket, :products, list_products())}
  end

  @impl
  def handle_event("to_sell", %{"id" => id}, socket) do
    product = Products.get_product!(id)

    case Products.sell_product(product) do
      {:ok, _} ->
        {:noreply,
         assign(
           socket
           |> put_flash(:info, "One #{product.name} is succesfully sold")
           |> push_redirect(to: Routes.product_index_path(socket, :index)),
           :products,
           list_products()
         )}

      {:error, :zero_product} ->
        {:noreply,
         socket
         |> put_flash(:error, "Sorry the product is out of stock")
         |> push_redirect(to: Routes.product_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "Sorry something went wrong")
         |> push_redirect(to: Routes.product_index_path(socket, :index))}
    end
  end

  defp list_products do
    Products.list_products()
  end
end
