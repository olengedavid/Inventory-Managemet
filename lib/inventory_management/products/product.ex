defmodule InventoryManagement.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias InventoryManagement.Products.Reorder
  alias InventoryManagement.Products.Sale
  alias InventoryManagement.Products.Restock

  schema "products" do
    field :inventory_amount, :integer
    field :name, :string
    field :reorder_level, :integer

    has_one :reorder, Reorder, foreign_key: :product_id
    has_many :sales, Sale
    has_many :restocks, Restock

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :inventory_amount, :reorder_level])
    |> validate_required([:name, :inventory_amount, :reorder_level])
  end
end
