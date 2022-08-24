defmodule InventoryManagement.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias InventoryManagement.Repo

  alias InventoryManagement.Products.Product
  alias InventoryManagement.Products.Reorder
  alias InventoryManagement.Products.Sale
  alias InventoryManagement.Products.Restock

  @quantity_sold 1
  @restocked_quantity 3
  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  def list_reorders do
    Repo.all(Reorder) |> Repo.preload(:product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  def sell_product(%Product{} = product) do
    if product.inventory_amount == 0 do
      {:error, :zero_product}
    else
      Repo.transaction(fn ->
        update_product(product, %{inventory_amount: product.inventory_amount - @quantity_sold})
        create_sale(%{product_id: product.id, quantity: @quantity_sold})
      end)

      product = get_product!(product.id)

      if product.inventory_amount == product.reorder_level do
        create_reorder(%{product_id: product.id, status: "unprocessed"})
      else
        {:ok, product}
      end
    end
  end

  def restock(%Product{} = product) do
    with {:ok, _anything} <-
           Repo.transaction(fn ->
             create_restock(%{product_id: product.id, quantity: @restocked_quantity})
             update_product(product, %{inventory_amount: @restocked_quantity})
           end) do
      reorder = get_reorder_by(product.id, "unprocessed")
      update_reorder(reorder, %{status: "processed"})
    end
  end

  def create_reorder(attrs \\ %{}) do
    %Reorder{}
    |> Reorder.changeset(attrs)
    |> Repo.insert()
  end

  def create_sale(attrs \\ %{}) do
    %Sale{}
    |> Sale.changeset(attrs)
    |> Repo.insert()
  end

  def create_restock(attrs \\ %{}) do
    %Restock{}
    |> Restock.changeset(attrs)
    |> Repo.insert()
  end

  def update_reorder(%Reorder{} = reorder, attrs) do
    reorder
    |> Reorder.changeset(attrs)
    |> Repo.update()
  end

  def get_reorder_by(product_id, status) do
    Reorder
    |> where([re], re.product_id == ^product_id and re.status == ^status)
    |> Repo.one()
  end
end
