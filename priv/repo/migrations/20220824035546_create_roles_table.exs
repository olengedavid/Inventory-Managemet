defmodule InventoryManagement.Repo.Migrations.CreateRolesTable do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :role, :string

      timestamps()
    end
  end
end
