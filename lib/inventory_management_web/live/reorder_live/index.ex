defmodule InventoryManagementWeb.ReorderLive.Index do
  use InventoryManagementWeb, :live_view

  alias InventoryManagement.Products.Reorder
  alias InventoryManagement.Products

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :reorders, list_reorders())}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def handle_event("restock", %{"id" => id}, socket) do
    product = Products.get_product!(id)

    case Products.restock(product) do
      {:ok, _} ->
        {:noreply,
         assign(
           socket
           |> put_flash(:info, "You have successfully dispatched #{product.name}")
           |> push_redirect(to: Routes.reorder_index_path(socket, :index)),
           :products,
           list_reorders()
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "Sorry something went wrong")
         |> push_redirect(to: Routes.reorder_index_path(socket, :index))}
    end
  end

  defp list_reorders do
    Products.list_reorders()
  end
end
