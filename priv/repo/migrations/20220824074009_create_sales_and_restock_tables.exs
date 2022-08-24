defmodule InventoryManagement.Repo.Migrations.CreateSalesAndRestockTables do
  use Ecto.Migration

  def change do
    create table(:sales) do
      add :quantity, :integer
      add :product_id, references(:products)

      timestamps()
    end

    create table(:restocks) do
      add :quantity, :integer
      add :product_id, references(:products)

      timestamps()
    end
  end
end
