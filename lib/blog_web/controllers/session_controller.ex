defmodule BlogWeb.SessionController do
  use BlogWeb, :controller

  def new(conn, _params) do
    changeset = Pow.Plug.change_user(conn)
    action = Routes.session_path(conn, :create)

    render(conn, "new.html", changeset: changeset, action: action)
  end

  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.authenticate_user(user_params)
    |> case do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.admin_path(conn, :show))

      {:error, conn} ->
        action = Routes.session_path(conn, :create)
        changeset = Pow.Plug.change_user(conn, conn.params["user"])

        conn
        |> put_flash(:info, "Invalid email or password")
        |> render("new.html", changeset: changeset, action: action)
    end
  end

  def delete(conn, _params) do
    conn
    |> Pow.Plug.delete()
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
