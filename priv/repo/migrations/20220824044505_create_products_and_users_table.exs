defmodule InventoryManagement.Repo.Migrations.CreateProductsAndusersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :password, :string
      add :email, :string
      add :role_id, :string

      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:products) do
      add :name, :string
      add :inventory_amount, :integer
      add :reorder_level, :integer

      timestamps()
    end
  end
end
