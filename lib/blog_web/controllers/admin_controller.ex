defmodule BlogWeb.AdminController do
  use BlogWeb, :controller

  alias Blog.Accounts

  plug :ensure_not_self when action in [:delete]

  def show(conn, _) do
    user = Pow.Plug.current_user(conn)
    changeset = Pow.Plug.change_user(conn)
    action = BlogWeb.Router.Helpers.admin_path(conn, :create)
    users = Blog.Accounts.list_users()

    render(conn, user: user, changeset: changeset, action: action, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    Accounts.create_user(user_params)
    |> case do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Admin Created Successfully")
        |> redirect(to: Routes.admin_path(conn, :show))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Can't create admin")
        |> redirect(to: Routes.admin_path(conn, :show), changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.admin_path(conn, :show))
  end

  defp ensure_not_self(conn, _) do
    id = conn.params["id"]
    if id == "#{Pow.Plug.current_user(conn).id}" do
      conn
      |> put_flash(:error, "You can't delete yourself.")
      |> redirect(to: Routes.admin_path(conn, :show))
      |> halt()
    else
      conn
    end
  end
end
