defmodule InventoryManagementWeb.Auth do
  @moduledoc false
  import Plug.Conn

  alias InventoryManagement.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      user_id = get_session(conn, :user_id)
      user = user_id && Accounts.get_user!(user_id)
      assign(conn, :current_user, user)
    end
  end

  def login_user(conn, email, password) do
    case Accounts.check_email_and_pass(email, password) do
      {:ok, user} -> {:ok, login(conn, user)}
      {:error, :unauthorized} -> {:error, :unauthorized, conn}
      {:error, :not_found} -> {:error, :not_found, conn}
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    conn
    |> configure_session(drop: true)
  end
end
