defmodule InventoryManagement.Accounts.Role do
  import Ecto.Changeset
  use Ecto.Schema

  InventoryManagement.Accounts.Role

  schema "roles" do
    field :name, :string
    has_many :users, User

    timestamps()
  end

  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
