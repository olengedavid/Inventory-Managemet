defmodule InventoryManagement.Accounts.User do
  import Ecto.Changeset
  use Ecto.Schema

  alias InventoryManagement.Accounts.Role

  schema "users" do
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :email, :string
    belongs_to :role, Role

    timestamps()
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :password, :role_id])
    |> unique_constraint(:email)
    |> _hash_password()
  end

  defp _hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
