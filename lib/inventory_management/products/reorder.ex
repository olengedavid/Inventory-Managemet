defmodule InventoryManagement.Products.Reorder do
  use Ecto.Schema
  import Ecto.Changeset

  alias InventoryManagement.Products.Product

  schema "reorders" do
    field :status, :string
    belongs_to :product, Product, foreign_key: :product_id

    timestamps()
  end

  def changeset(reorder, attrs \\ %{}) do
    reorder
    |> cast(attrs, [:status, :product_id])
    |> validate_required([:status, :product_id])
    |> unique_constraint([:status, :product_id])
  end
end
