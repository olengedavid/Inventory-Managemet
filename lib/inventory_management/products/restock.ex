defmodule InventoryManagement.Products.Restock do
  use Ecto.Schema
  import Ecto.Changeset

  alias InventoryManagement.Products.Product

  schema "restocks" do
    field :quantity, :integer
    belongs_to :product, Product, foreign_key: :product_id
  end

  def changeset(restock, attrs \\ %{}) do
    restock
    |> cast(attrs, [:quantity, :product_id])
    |> validate_required([:quantity, :product_id])
  end
end
