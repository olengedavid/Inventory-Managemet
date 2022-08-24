defmodule InventoryManagement.Repo.Migrations.CreateReordersTable do
  use Ecto.Migration

  def change do
    create table(:reorders) do
      add :status, :string
      add :product_id, references(:products)
    end

    create unique_index(:reorders, [:product_id, :status])
  end
end
