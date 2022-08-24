defmodule InventoryManagement.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InventoryManagement.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        inventory_amount: 42,
        name: "some name",
        reorder_level: 42
      })
      |> InventoryManagement.Products.create_product()

    product
  end
end
