defmodule InventoryManagement.Products.Sale do
  use Ecto.Schema
  import Ecto.Changeset

  alias InventoryManagement.Products.Product

  schema "sales" do
    field :quantity, :integer
    belongs_to :product, Product, foreign_key: :product_id

    timestamps()
  end

  def changeset(sales, attrs \\ %{}) do
    sales
    |> cast(attrs, [:quantity, :product_id])
    |> validate_required([:quantity, :product_id])
  end
end
