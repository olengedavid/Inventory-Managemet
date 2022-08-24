defmodule InventoryManagement.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :inventory_amount, :integer
      add :reorder_level, :integer

      timestamps()
    end
  end
end
